return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ lsp_format = "fallback" }) end,
      desc = "Format file",
    },
  },
  opts = {
    formatters_by_ft = {
      lua        = { "stylua" },
      javascript = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      python     = { "black" },
      json       = { "prettier" },
      yaml       = { "prettier" },
      markdown   = { "prettier" },
    },
    -- Fall back to LSP formatting if no formatter is configured for the filetype
    default_format_opts = { lsp_format = "fallback" },
  },
}
