local api = require("smm.spotify.requests")
local utils = require("smm.playback.utils")
local logger = require("smm.utils.logger")
local media = require("smm.search.media")
local device = require("smm.search.device")

local M = {}

local function get_error_message(response_body)
  if type(response_body) == "table" then
    if type(response_body.error) == "table" then
      return response_body.error.message or ""
    end

    return response_body.message or ""
  end

  if type(response_body) == "string" then
    return response_body
  end

  return ""
end

local function is_premium_required_error(response_body, status_code)
  if status_code ~= 403 then
    return false
  end

  local message = get_error_message(response_body):lower()
  return message:find("active premium subscription required", 1, true) ~= nil
end

local function fail_premium_session()
  vim.schedule(function()
    require("smm.playback").fail_session(
      "Spotify blocked playback for this app because the app owner's account does not have an active Premium subscription."
    )
  end)
end

function M.create_sync_handler(on_playback_update)
  return function(callback)
    api.get_playback_state(function(playback_response, playback_headers, status_code)
      if status_code == 200 or status_code == 204 then
        local playback_info = utils.get_playbackinfo(playback_response)
        logger.debug("Playback Info:\n%s", vim.inspect(playback_info))

        if on_playback_update then
          on_playback_update(playback_info, status_code)
        end

        if playback_info and playback_info.progress_ms and playback_info.playing ~= nil then
          callback({
            current_pos = playback_info.progress_ms,
            is_playing = playback_info.playing,
          })
        else
          callback(nil)
        end
      elseif status_code >= 500 and status_code <= 510 then
        logger.warn("Received status code: %d - Will try again next sync", status_code)
        if on_playback_update then
          on_playback_update(nil, status_code)
        end
        callback(nil)
      elseif is_premium_required_error(playback_response, status_code) then
        if on_playback_update then
          on_playback_update(nil, status_code)
        end
        callback(nil)
        fail_premium_session()
      else
        logger.error(
          "Getting playback state failed:\nStatus Code: %s\nError: %s",
          status_code,
          vim.inspect(playback_response)
        )
        if on_playback_update then
          on_playback_update(nil, status_code)
        end
        callback(nil)
      end
    end, true)
  end
end

function M.create_update_handler(get_playback_info, on_interface_update)
  return function(current_ms)
    local END_SONG_BUFFER = 200
    local playback_info = get_playback_info()

    if not playback_info or not current_ms then
      on_interface_update(nil)
      return false
    end

    if playback_info.is_advertisement then
      playback_info.progress_ms = current_ms
      on_interface_update(playback_info)
      return false
    end

    if not playback_info.track then
      on_interface_update(nil)
      return false
    end

    if playback_info.progress_ms >= playback_info.track.duration_ms - END_SONG_BUFFER then
      return true
    end

    playback_info.progress_ms = current_ms
    on_interface_update(playback_info)
    return false
  end
end

function M.create_pause_handler(get_timer, update_playback_info)
  return function()
    api.pause(function(pause_response, pause_headers, status_code)
      local timer = get_timer()
      if status_code == 200 or status_code == 204 then
        if timer then
          timer:pause()
        end
        update_playback_info({ playing = false })
      else
        logger.error(
          "Unable to pause current track:\nStatus Code: %s\nError: %s",
          status_code,
          vim.inspect(pause_response)
        )
      end
    end)
  end
end

function M.create_play_handler(get_timer, update_playback_info)
  return function(context_uri, offset, position_ms)
    position_ms = position_ms or 0

    api.play(
      context_uri,
      offset,
      position_ms,
      function(resume_response, resume_headers, status_code)
        local timer = get_timer()
        if status_code == 200 or status_code == 204 then
          if timer then
            timer:resume()
          end
          update_playback_info({ playing = true })
        else
          logger.error(
            "Unable to play track:\nStatus Code: %s\nError: %s",
            status_code,
            vim.inspect(resume_response)
          )
        end
      end
    )
  end
end

function M.create_next_handler()
  return function()
    api.next(function(next_response, next_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully skipped to next track")
      else
        logger.error(
          "Unable to skip to next track:\nStatus Code: %s\nError: %s",
          status_code,
          vim.inspect(next_response)
        )
      end
    end)
  end
end

function M.create_previous_handler()
  return function()
    api.previous(function(previous_response, previous_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully skipped to previous track")
      else
        logger.error(
          "Unable to skip to previous track:\nStatus Code: %s\nError: %s",
          status_code,
          vim.inspect(previous_response)
        )
      end
    end)
  end
end

function M.create_transfer_playback_handler(update_playback_info)
  return function(selected_device)
    api.transfer_playback_state(
      selected_device.id,
      function(transfer_response, transfer_headers, status_code)
        if status_code == 200 or status_code == 204 then
          logger.debug(
            "Successfully changed playback to ID: %s - %s",
            selected_device.name,
            selected_device.id
          )
          update_playback_info({
            device_id = selected_device.id,
          })
        else
          logger.error(
            "Unable to transfer playback:\nStatus Code: %s\nError: %s",
            status_code,
            vim.inspect(transfer_response)
          )
        end
      end
    )
  end
end

function M.create_shuffle_handler(update_playback_info)
  return function(state)
    api.change_shuffle_state(state, function(shuffle_response, shuffle_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully changed shuffle state to: %s", tostring(state))
        update_playback_info({
          shuffle_state = state,
        })
      else
        logger.error(
          "Unable to change shuffle state:\nStatus Code: %s\nError: %s",
          status_code,
          vim.inspect(shuffle_response)
        )
      end
    end)
  end
end

function M.create_repeat_handler(update_playback_info)
  return function(state)
    api.change_repeat_state(state, function(repeat_response, repeat_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully changed repeat state to: %s", state)
        update_playback_info({
          repeat_state = state,
        })
      end
    end)
  end
end

function M.create_media_search_handler(on_selected)
  return function(search_type, query)
    local has_telescope, _ = pcall(require, "telescope")
    if not has_telescope then
      logger.error(
        "Telescope is required for search functionality. Please install nvim-telescope/telescope.nvim as a dependency"
      )
      return
    end
    api.search(query, search_type, 20, 0, function(search_body, search_headers, status_code)
      if status_code ~= 200 then
        logger.error(
          "Search failed. Status: %d, Response: %s",
          status_code,
          vim.inspect(search_body)
        )
        return
      end

      local results = media.parse_search_results(search_body, search_type)

      if #results == 0 then
        logger.info("No %s found for query: %s", search_type, query)
        return
      end

      vim.schedule(function()
        media.show_results_window(results, search_type, on_selected)
      end)
    end)
  end
end

function M.create_device_search_handler(on_selected)
  return function()
    local has_telescope, _ = pcall(require, "telescope")
    if not has_telescope then
      logger.error(
        "Telescope is required for search functionality. Please install nvim-telescope/telescope.nvim as a dependency"
      )
      return
    end

    api.get_available_devices(function(device_response, device_headers, status_code)
      if status_code ~= 200 then
        logger.error(
          "Search for device failed. Status: %d, Response: %s",
          status_code,
          vim.inspect(device_response)
        )
        return
      end

      local results = device.parse_search_results(device_response)

      if #results == 0 then
        logger.info("No devices found. Please start a playback session from a device.")
        return
      end

      vim.schedule(function()
        device.show_results_window(results, on_selected)
      end)
    end)
  end
end

function M.create_add_liked_song_handler()
  return function(id)
    api.like_song(id, function(like_response, like_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully liked track")
        return
      end
    end)
  end
end

function M.create_delete_liked_song_handler()
  return function(id)
    api.unlike_song(id, function(unlike_response, unlike_headers, status_code)
      if status_code == 200 or status_code == 204 then
        logger.debug("Successfully liked track")
        return
      end
    end)
  end
end

return M
