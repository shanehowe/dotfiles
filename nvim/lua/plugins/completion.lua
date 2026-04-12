return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		keymap = {
			preset = "super-tab", -- Tab accepts completion, Shift-Tab moves backward
			["<CR>"] = { "accept", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		sources = { default = { "lsp", "path", "buffer" } },
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = "single" },
			},
		},
	},
}
