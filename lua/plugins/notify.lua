return {
  "rcarriga/nvim-notify",
  opts = {
    background_colour = "#0d1117",
    timeout = 3000,
    max_width = 80,
    top_down = false,
    render = "compact",
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
