return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- Tell lua_ls about the Neovim runtime so it recognises `vim` as a valid global
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",       -- Lua
				"pyright",      -- Python
				"ts_ls",        -- TypeScript / JavaScript
				"rust_analyzer", -- Rust
				-- Java is handled by nvim-jdtls
			},
			automatic_enable = true, -- calls vim.lsp.enable() for every installed server
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gd", vim.lsp.buf.definition, "Go to Definition")
				map("gI", vim.lsp.buf.implementation, "Go to [I]mplementation")
				map("gr", vim.lsp.buf.references, "Go to References")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			end,
		})
	end,
}
