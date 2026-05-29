vim.env.POWERSHELL_UPDATECHECK = "Off"

local Terminal = require("toggleterm.terminal").Terminal
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local shell_command = vim.fn.executable("pwsh") == 1 and "pwsh -NoLogo" or vim.o.shell

local function clean_terminal_name(value)
  if not value or value == "" then
    return nil
  end

  value = value:gsub("::toggleterm::%d+", "")
  value = value:gsub("[&;]+$", "")
  value = vim.trim(value)

  local exe = value:match("([^\\/%s]+%.exe)") or value:match("([^\\/%s]+)$")
  return exe or value
end

local shell_name = clean_terminal_name(shell_command) or vim.fn.fnamemodify(vim.o.shell, ":t")

require("toggleterm").setup({
  direction = "float",
  shell = shell_command,
  start_in_insert = true,
  insert_mappings = true,
  float_opts = {
    border = "rounded",
  },
})

local terminals = {}
local last_terminal

local function send_ctrl_w_to_terminal(terminal)
  if terminal and terminal.job_id then
    vim.api.nvim_chan_send(terminal.job_id, "\x17")
  end
end

local function create_terminal()
  local terminal = Terminal:new({
    direction = "float",
    hidden = true,
    on_open = function(term)
      vim.schedule(function()
        local term_opts = { buffer = term.bufnr, silent = true, noremap = true }
        map("t", "<C-BS>", function()
          send_ctrl_w_to_terminal(term)
        end, term_opts)
        map("t", "<C-h>", function()
          send_ctrl_w_to_terminal(term)
        end, term_opts)
        map("t", "<C-w>", function()
          send_ctrl_w_to_terminal(term)
        end, term_opts)
        vim.cmd("startinsert!")
      end)
    end,
  })

  table.insert(terminals, terminal)
  return terminal
end

local function process_name_from_pid(pid)
  if pid <= 0 then
    return nil
  end

  local command = table.concat({
    "$ErrorActionPreference = 'SilentlyContinue'",
    "$targetPid = " .. pid,
    "$skip = @('pwsh.exe', 'powershell.exe', 'cmd.exe', 'conhost.exe')",
    "$all = Get-CimInstance Win32_Process",
    "$desc = New-Object System.Collections.Generic.List[object]",
    "$queue = New-Object System.Collections.Generic.Queue[uint32]",
    "$queue.Enqueue([uint32]$targetPid)",
    "while ($queue.Count -gt 0) {",
    "  $parent = $queue.Dequeue()",
    "  $children = @($all | Where-Object ParentProcessId -eq $parent)",
    "  foreach ($child in $children) {",
    "    $desc.Add($child)",
    "    $queue.Enqueue([uint32]$child.ProcessId)",
    "  }",
    "}",
    "$pick = $desc | Where-Object { $_.Name -notin $skip } | Select-Object -Last 1",
    "if (-not $pick) { $pick = $desc | Select-Object -Last 1 }",
    "if ($pick) { $pick.Name }",
  }, "; ")

  local result = vim.fn.systemlist({ "pwsh", "-NoLogo", "-NoProfile", "-Command", command })
  if vim.v.shell_error ~= 0 or not result[1] or result[1] == "" then
    return nil
  end

  return result[1]
end

local function terminal_process_name(terminal)
  local job_id = terminal.job_id
  if job_id then
    local pid = vim.fn.jobpid(job_id)
    local process_name = process_name_from_pid(pid)
    local clean_process_name = clean_terminal_name(process_name)
    if clean_process_name and clean_process_name ~= shell_name then
      return clean_process_name
    end
  end

  local title = clean_terminal_name(terminal.display_name or terminal.name)
  if title and title ~= shell_name then
    return title
  end

  local cmd = clean_terminal_name(terminal.cmd)
  if cmd and cmd ~= shell_name then
    return cmd
  end

  return shell_name
end

local function terminal_picker_label(terminal, index)
  local id = terminal.id or index
  return string.format("%s: %s", id, terminal_process_name(terminal))
end

local function toggle_last_terminal()
  if not last_terminal then
    last_terminal = create_terminal()
  end

  last_terminal:toggle()
end

local function new_terminal()
  last_terminal = create_terminal()
  last_terminal:toggle()
end

local function remove_terminal(terminal)
  for index, item in ipairs(terminals) do
    if item == terminal then
      table.remove(terminals, index)
      break
    end
  end

  if last_terminal == terminal then
    last_terminal = terminals[#terminals]
  end

  terminal:shutdown()
end

local function select_terminal()
  if #terminals == 0 then
    new_terminal()
    return
  end

  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.ERROR)
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entries = {}

  for index, terminal in ipairs(terminals) do
    local label = terminal_picker_label(terminal, index)
    table.insert(entries, {
      value = terminal,
      ordinal = label,
      display = label,
    })
  end

  pickers.new({}, {
    prompt_title = "Terminals",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return entry
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        last_terminal = selection.value
        last_terminal:toggle()
      end)

      local function delete_selected_terminal()
        local selection = action_state.get_selected_entry()
        if not selection then
          return
        end

        remove_terminal(selection.value)
        actions.close(prompt_bufnr)

        if #terminals > 0 then
          select_terminal()
        end
      end

      vim.keymap.set("i", "<C-d>", delete_selected_terminal, { buffer = prompt_bufnr, silent = true })
      vim.keymap.set("n", "<C-d>", delete_selected_terminal, { buffer = prompt_bufnr, silent = true })
      vim.keymap.set("n", "dd", delete_selected_terminal, { buffer = prompt_bufnr, silent = true })

      return true
    end,
  }):find()
end

local function close_last_terminal()
  if last_terminal then
    last_terminal:close()
  end
end

for _, lhs in ipairs({ "<C-\\>", "<C-`>", "<Nul>", "<C-Space>", "<C-@>" }) do
  map({ "n", "t" }, lhs, toggle_last_terminal, opts)
end
map("n", "<leader>tn", new_terminal, opts)
map("n", "<leader>ts", select_terminal, opts)
map("n", "<leader>tk", close_last_terminal, opts)
