local M = {}

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function unquote(value)
  local first = value:sub(1, 1)
  local last = value:sub(-1)

  if (first == '"' and last == '"') or (first == "'" and last == "'") then
    return value:sub(2, -2)
  end

  return value
end

function M.load(path)
  local file = io.open(path, "r")

  if not file then
    return false
  end

  for line in file:lines() do
    local content = trim(line)

    if content ~= "" and not content:match("^#") then
      local key, value = content:match("^([%w_]+)%s*=%s*(.*)$")

      if key and vim.env[key] == nil then
        vim.env[key] = unquote(trim(value))
      end
    end
  end

  file:close()
  return true
end

return M
