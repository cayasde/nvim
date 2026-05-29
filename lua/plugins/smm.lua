local function env_bool(name, default)
  local value = vim.env[name]

  if value == nil or value == "" then
    return default
  end

  value = value:lower()

  return value == "1" or value == "true" or value == "yes" or value == "on"
end

local function env_number(name, default)
  local value = tonumber(vim.env[name])

  if value == nil then
    return default
  end

  return value
end

return {
  "iamt4nk/smm.nvim",
  cmd = {
    "Spotify",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local ok, err = pcall(vim.api.nvim_del_user_command, "Spotify")

    if not ok and not tostring(err):match("E184") then
      vim.notify("smm.nvim command bootstrap could not be reset cleanly", vim.log.levels.WARN)
    end

    require("smm").setup({
      premium = env_bool("SPOTIFY_PREMIUM", true),
      icons = true,
      playback = {
        timer_update_interval = 250,
        timer_sync_interval = 5000,
        playback_pos = "BottomRight",
        playback_width = 40,
        progress_bar_width = 35,
        song_links = true,
      },
      spotify = {
        api_retry_max = 3,
        api_retry_backoff = 2000,
        auth = {
          client_id = vim.env.SPOTIFY_CLIENT_ID or "",
          callback_url = vim.env.SPOTIFY_CALLBACK_URL or "http://127.0.0.1",
          callback_port = env_number("SPOTIFY_CALLBACK_PORT", 8888),
        },
      },
    })
  end,
}
