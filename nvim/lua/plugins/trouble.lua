return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>",                 desc = "Quickfix (Trouble)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols (Trouble)" },
  },
}
