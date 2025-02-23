return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-rspec",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-rspec")({
					rspec_cmd = function()
						return vim.tbl_flatten({
							"bundle",
							"exec",
							"rspec",
						})
					end,
					root_files = { "Gemfile", ".rspec", ".gitignore" },
					filter_dirs = { ".git", "node_modules" },
					transform_spec_path = function(path)
						return path
					end,
				}),
			},
		})
	end,
}
