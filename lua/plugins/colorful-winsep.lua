return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
  config = function()
    require("colorful-winsep").setup({
      border = "bold",
      excluded_ft = { "packer", "TelescopePrompt", "mason", "lazy", "oil" },
      highlight = "#79c0ff",
      animate = {
        enabled = "progressive",
        progressive = {
          delay = 16,
          vertical_lerp_factor = 0.15,
          horizontal_lerp_factor = 0.15,
        },
      },
      indicator_for_2wins = {
        position = false,
      },
    })
  end,
}
