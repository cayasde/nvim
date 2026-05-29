local M = {}

local LOG_LEVELS = {
  DEBUG = { level = 1, notify = vim.log.levels.DEBUG, prefix = "[DEBUG]" },
  INFO = { level = 2, notify = vim.log.levels.INFO, prefix = "[INFO]" },
  WARN = { level = 3, notify = vim.log.levels.WARN, prefix = "[WARN]" },
  ERROR = { level = 4, notify = vim.log.levels.ERROR, prefix = "[ERROR]" },
}

local debug_level = false
local log_file = ""
local enabled = true

local function emit_message(level, message)
  local notify_level = LOG_LEVELS[level].notify

  if log_file ~= "" then
    local file = io.open(log_file, "a+")

    if not file then
      error("Failed to open log file")
    end

    file:write(message .. "\n")
    file:close()
    return
  end

  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(message, notify_level, { title = "smm.nvim" })
    end)
    return
  end

  vim.notify(message, notify_level, { title = "smm.nvim" })
end

local function log(level, message, ...)
  local log_config = LOG_LEVELS[level]

  if not log_config or not enabled then
    return
  end

  local should_log = log_config.level > 1 or debug_level

  if not should_log then
    return
  end

  local formatted_msg = ... and string.format(message, ...) or message
  local full_message = string.format("%s smm.nvim %s", log_config.prefix, formatted_msg)

  emit_message(level, full_message)
end

function M.setup(debug, file)
  debug_level = debug ~= false
  log_file = file or ""
end

function M.error(message, ...)
  log("ERROR", message, ...)
end

function M.warn(message, ...)
  log("WARN", message, ...)
end

function M.info(message, ...)
  log("INFO", message, ...)
end

function M.debug(message, ...)
  log("DEBUG", message, ...)
end

return M
