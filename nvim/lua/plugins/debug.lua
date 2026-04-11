return {
  -- Core DAP client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup()

          -- Auto-open/close UI when debugging starts/ends
          dap.listeners.before.attach.dapui_config    = function() dapui.open() end
          dap.listeners.before.launch.dapui_config    = function() dapui.open() end
          dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
          dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end
        end,
      },
      -- Mason bridge for auto-installing debug adapters
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
          require("mason-nvim-dap").setup({
            ensure_installed = {
              "debugpy",        -- Python
              "js-debug-adapter", -- TypeScript / JavaScript
              "codelldb",       -- Rust
              -- Java is handled by nvim-jdtls
            },
            handlers = {},     -- use default_setup for all adapters
          })
        end,
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,          desc = "Debug: Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                   desc = "Debug: Continue" },
      { "<leader>di", function() require("dap").step_into() end,                  desc = "Debug: Step into" },
      { "<leader>do", function() require("dap").step_over() end,                  desc = "Debug: Step over" },
      { "<leader>dO", function() require("dap").step_out() end,                   desc = "Debug: Step out" },
      { "<leader>dt", function() require("dap").terminate() end,                  desc = "Debug: Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,                   desc = "Debug: Toggle UI" },
    },
    config = function()
      local dap = require("dap")

      -- TypeScript / JavaScript
      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
      dap.configurations.javascript = dap.configurations.typescript

      -- Rust (codelldb adapter configured by mason-nvim-dap)
      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch binary",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },

  -- Java LSP + DAP (jdtls handles both)
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("jdtls.jdtls_setup").setup()
        end,
      })
    end,
  },
}
