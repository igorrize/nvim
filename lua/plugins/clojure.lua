return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts = opts or {}
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "clojure" })
		end,
	},

	{
		"Olical/conjure",
		ft = { "clojure", "edn" },
		init = function()
			vim.g["conjure#mapping#doc_word"] = "gK"
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
			vim.g["conjure#log#hud#width"] = 0.6
			vim.g["conjure#log#hud#anchor"] = "SE"
			vim.g["conjure#log#botright"] = true
		end,
	},

	{
		"julienvincent/nvim-paredit",
		ft = { "clojure", "edn" },
		config = function()
			require("nvim-paredit").setup({
				use_default_keys = true,
				cursor_behaviour = "auto",
				indent = { enabled = true },
			})
		end,
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
		ft = { "clojure", "edn", "scheme", "lisp" },
	},
}
