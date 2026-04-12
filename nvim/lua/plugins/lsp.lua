return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	config = function()
		local diagnostic_config = { virtual_text = false }
		if vim.fn.has("nvim-0.10") == 1 then
			diagnostic_config.virtual_lines = true
		else
			diagnostic_config.virtual_text = true
		end
		vim.diagnostic.config(diagnostic_config)

		vim.ui.select = function(items, opts, on_choice)
			local title = opts.prompt or "Select"
			local format_item = opts.format_item or tostring

			local lines = {}
			for _, item in ipairs(items) do
				table.insert(lines, "  " .. format_item(item))
			end

			local width = #title + 4
			for _, line in ipairs(lines) do
				width = math.max(width, #line + 4)
			end

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
			vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

			local ui = vim.api.nvim_list_uis()[1]
			local height = #lines
			local row = math.floor((ui.height - height) / 2)
			local col = math.floor((ui.width - width) / 2)

			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				row = row,
				col = col,
				width = width,
				height = height,
				style = "minimal",
				border = "rounded",
				title = " " .. title .. " ",
				title_pos = "center",
			})
			vim.api.nvim_set_option_value("cursorline", true, { win = win })

			local function confirm()
				local idx = vim.api.nvim_win_get_cursor(win)[1]
				vim.api.nvim_win_close(win, true)
				on_choice(items[idx], idx)
			end

			local function cancel()
				vim.api.nvim_win_close(win, true)
				on_choice(nil, nil)
			end

			local map_opts = { buffer = buf, nowait = true }
			vim.keymap.set("n", "<CR>", confirm, map_opts)
			vim.keymap.set("n", "<Esc>", cancel, map_opts)
			vim.keymap.set("n", "q", cancel, map_opts)
		end

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
