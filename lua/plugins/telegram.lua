return {
	{
		"ChuYanLon/telegram.nvim",
		build = "npm i",
		event = "VeryLazy",
		dependencies = { "folke/snacks.nvim" },
		-- <leader>t* is taken (rails-spec-toggle, git-worktree), so Telegram sits on <leader>T.
		keys = {
			{ "<leader>Tt", "<cmd>Tg<CR>", desc = "Toggle Telegram" },
			{ "<leader>TL", "<cmd>TgLogout<CR>", desc = "Logout Telegram" },
			{ "<leader>Tp", "<cmd>TgPr<CR>", desc = "Create PR" },
			{ "<leader>Ti", "<cmd>TgIssue<CR>", desc = "Manage Issues" },
		},
		cmd = { "Tg", "TgLogout", "TgPr", "TgIssue" },
		opts = {
			-- libtdjson is auto-detected; /opt/homebrew/lib is on the macOS probe list.
			-- tdlib_path = "/opt/homebrew/lib/libtdjson.dylib",
		},
	},
}
