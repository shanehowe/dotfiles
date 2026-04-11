return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	opts = {},
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find git files" },
		{ "<leader>fl", "<cmd>FzfLua live_grep<cr>", desc = "Find in files (grep)" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
		{ "<leader>fr", "<cmd>FzfLua oldfiles cwd_only=true<cr>", desc = "Find recent project files" },
		{ "<leader>fs", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
	},
}
