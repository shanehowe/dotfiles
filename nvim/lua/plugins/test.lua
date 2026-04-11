return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    -- Adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
    "rcasia/neotest-java",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
          args = { "--tb=short" },
        }),
        require("neotest-jest")({
          jestCommand = "npx jest",
        }),
        require("neotest-rust")({
          dap_adapter = "codelldb",
        }),
        require("neotest-java")({
          runner = "maven", -- change to "gradle" if needed
        }),
      },
    })
  end,
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                              desc = "Test: Run nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,            desc = "Test: Run file" },
    { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end,                  desc = "Test: Run all" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,                       desc = "Test: Toggle summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end,          desc = "Test: Show output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end,                  desc = "Test: Toggle output panel" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,          desc = "Test: Debug nearest" },
  },
}
