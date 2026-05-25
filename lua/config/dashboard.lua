local M = {}

local user = "cayasde"
local accents = {
  title = "DashboardContributionTitle",
  muted = "DashboardContributionMuted",
}

local state = {
  lines = nil,
}

local function cache_path()
  return vim.fs.joinpath(vim.fn.stdpath("cache"), "dashboard", user .. "-contributions.json")
end

local function read_file(path)
  local fd = vim.uv.fs_open(path, "r", 438)
  if not fd then
    return nil
  end

  local stat = vim.uv.fs_fstat(fd)
  local data = stat and vim.uv.fs_read(fd, stat.size, 0) or nil
  vim.uv.fs_close(fd)
  return data
end

local function write_file(path, content)
  vim.fn.mkdir(vim.fs.dirname(path), "p")

  local fd = vim.uv.fs_open(path, "w", 420)
  if not fd then
    return
  end

  vim.uv.fs_write(fd, content, 0)
  vim.uv.fs_close(fd)
end

local function parse_total(html)
  local total = html:match("<h2.-id=\"js%-contribution%-activity%-description\".-%f[>%s]>(.-)</h2>")
  if not total then
    return nil
  end

  total = total:gsub("<.->", " ")
  total = total:gsub("&nbsp;", " ")
  total = total:gsub("%s+", " ")
  total = vim.trim(total)

  local count = total:match("([%d,]+)")
  return count, total
end

local function fetch_total()
  if vim.fn.executable("curl") ~= 1 then
    return nil
  end

  local result = vim.system({
    "curl",
    "-fsSL",
    "https://github.com/users/" .. user .. "/contributions",
  }, { text = true }):wait()

  if result.code ~= 0 or not result.stdout or result.stdout == "" then
    return nil
  end

  local count, full = parse_total(result.stdout)
  if not count or not full then
    return nil
  end

  local payload = {
    count = count,
    full = full,
    fetched_at = os.time(),
  }

  write_file(cache_path(), vim.json.encode(payload))
  return payload
end

local function load_total()
  local content = read_file(cache_path())
  if content and content ~= "" then
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and data.count and data.full and data.fetched_at and (os.time() - data.fetched_at) < 86400 then
      return data
    end
  end

  return fetch_total() or {
    count = "0",
    full = "0 contributions in the last year",
  }
end

local function center(text, width)
  local pad = math.max(0, math.floor((width - vim.api.nvim_strwidth(text)) / 2))
  return string.rep(" ", pad) .. text
end

local function build_lines()
  local total = load_total()
  local width = 78
  local lines = {
    "",
    center(total.full, width),
    "",
  }

  return lines
end

local function set_highlights()
  vim.api.nvim_set_hl(0, accents.title, { fg = "#58a6ff", bold = true })
  vim.api.nvim_set_hl(0, accents.muted, { fg = "#8b949e" })
end

function M.build()
  state.lines = build_lines()
  return state.lines
end

function M.apply(bufnr)
  state.lines = build_lines()
  vim.api.nvim_buf_set_lines(bufnr, 0, #state.lines, false, state.lines)
  set_highlights()
  vim.api.nvim_buf_add_highlight(bufnr, 0, accents.title, 1, 0, -1)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CayasdeDashboardHeader", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "dashboard",
    callback = function(args)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          M.apply(args.buf)
        end
      end)
    end,
  })
end

return M
