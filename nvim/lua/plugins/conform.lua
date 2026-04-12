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
      java       = { "palantir" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
    formatters = {
      palantir = {
        command = vim.fn.expand("~/.local/share/java-formatters/palantir-java-format"),
        args = { "--palantir", "-" },
        stdin = true,
      },
    },
  },
}
