return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- auto-picks latte (light) or mocha (dark) based on vim.o.background
      background = {
        light = "latte",
        dark = "mocha",
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
  keys = {
    {
      "<leader>tt",
      function()
        if vim.o.background == "dark" then
          vim.o.background = "light"
        else
          vim.o.background = "dark"
        end
      end,
      desc = "Toggle light/dark theme",
    },
  },
}
