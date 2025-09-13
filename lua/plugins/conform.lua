return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			ruby = { "rubocop" },
			go = { "goimports_reviser", "gofumpt" },
		},

		formatters = {
			rubocop = {
				command = function()
					if vim.fn.executable("mise") == 1 and vim.fn.filereadable(".mise.toml") == 1 then
						return "mise"
					elseif vim.fn.executable("bundle") == 1 and vim.fn.filereadable("Gemfile") == 1 then
						return "bundle"
					else
						return "rubocop"
					end
				end,
				args = function()
					if vim.fn.executable("mise") == 1 and vim.fn.filereadable(".mise.toml") == 1 then
						return {
							"exec",
							"--",
							"bundle",
							"exec",
							"rubocop",
							"--auto-correct",
							"--stdin",
							"$FILENAME",
							"--format",
							"quiet",
							"--stderr",
						}
					elseif vim.fn.executable("bundle") == 1 and vim.fn.filereadable("Gemfile") == 1 then
						return {
							"exec",
							"rubocop",
							"--auto-correct",
							"--stdin",
							"$FILENAME",
							"--format",
							"quiet",
							"--stderr",
						}
					else
						return { "--auto-correct", "--stdin", "$FILENAME", "--format", "quiet", "--stderr" }
					end
				end,
				stdin = true,
			},
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
