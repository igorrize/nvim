-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({
					async = false,
					lsp_fallback = true,
					timeout_ms = 3000,
				})
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			ruby = { "rubocop" }, -- ИЗМЕНЕНО с rubyfmt на rubocop
			go = { "gofumpt", "goimports" },
		},
		formatters = {
			rubocop = {
				command = "rubocop",
				args = {
					"--autocorrect-all",
					"--stdin",
					"$FILENAME",
					"--format",
					"quiet",
					"--stderr",
				},
				stdin = true,
			},
		},
		format_on_save = false, -- ОТКЛЮЧАЕМ автоформат при сохранении
		notify_on_error = true,
	},
}
