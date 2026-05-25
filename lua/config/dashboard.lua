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

local function ensure_dir(path)
  if path == nil or path == "" or vim.uv.fs_stat(path) then
    return
  end

  ensure_dir(vim.fs.dirname(path))
  vim.uv.fs_mkdir(path, 493)
end

local function write_file(path, content)
  ensure_dir(vim.fs.dirname(path))

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

local function load_cached_total()
  local content = read_file(cache_path())

  if content and content ~= "" then
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and data.count and data.full then
      return data
    end
  end

  return {
    count = "0",
    full = "0 contributions in the last year",
  }
end

local function fetch_total_async(on_done)
  if vim.fn.executable("curl") ~= 1 then
    return
  end

  vim.system({
    "curl",
    "-fsSL",
    "https://github.com/users/" .. user .. "/contributions",
  }, { text = true }, function(result)
    if result.code ~= 0 or not result.stdout or result.stdout == "" then
      return
    end

    local count, full = parse_total(result.stdout)
    if not count or not full then
      return
    end

    local payload = {
      count = count,
      full = full,
      fetched_at = os.time(),
    }

    write_file(cache_path(), vim.json.encode(payload))

    if on_done then
      vim.schedule(function()
        on_done(payload)
      end)
    end
  end)
end

local function center(text, width)
  local pad = math.max(0, math.floor((width - vim.api.nvim_strwidth(text)) / 2))
  return string.rep(" ", pad) .. text
end

local function build_lines(total)
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
  state.lines = build_lines(load_cached_total())
  return state.lines
end

function M.apply(bufnr)
  local cached = load_cached_total()
  state.lines = build_lines(cached)
  vim.api.nvim_buf_set_lines(bufnr, 0, #state.lines, false, state.lines)
  set_highlights()
  vim.api.nvim_buf_add_highlight(bufnr, 0, accents.title, 1, 0, -1)

  fetch_total_async(function(total)
    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "dashboard" then
      return
    end

    if total.full == cached.full then
      return
    end

    state.lines = build_lines(total)
    vim.api.nvim_buf_set_lines(bufnr, 0, #state.lines, false, state.lines)
    vim.api.nvim_buf_add_highlight(bufnr, 0, accents.title, 1, 0, -1)
  end)
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
