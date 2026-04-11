return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    preset = "default",
    triggers = {
      { "<auto>", mode = "nxso" }, -- auto-trigger in normal, visual, select, operator-pending
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Show keymaps (which-key)",
    },
    {
      "<leader>?",
      function() require("which-key").show({ mode = "v" }) end,
      mode = "v",
      desc = "Show visual keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Keep visual selection active after indenting/dedenting
    vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })
    vim.keymap.set("v", "<", "<gv", { desc = "Dedent selection" })
  end,
}
