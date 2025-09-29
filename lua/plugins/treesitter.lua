return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },

				textobjects = {
					select = {
						enable = true,
						lookahead = true,

						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",

							["ac"] = "@class.outer",
							["ic"] = "@class.inner",

							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",

							["ab"] = "@block.outer",
							["ib"] = "@block.inner",

							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",

							["al"] = "@loop.outer",
							["il"] = "@loop.inner",

							["aC"] = "@comment.outer",
						},
					},

					move = {
						enable = true,
						set_jumps = true,

						goto_next_start = {
							["]m"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]C"] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[c"] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[C"] = "@class.outer",
						},
					},

					swap = {
						enable = true,
						swap_next = {
							["<leader>sp"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>sP"] = "@parameter.inner",
						},
					},
				},
			})
			
			-- ДОБАВЛЯЕМ FOLDING НАСТРОЙКИ ПОСЛЕ setup()
			-- Включаем TreeSitter-based folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldlevel = 99  -- Все открыто по умолчанию
			vim.opt.foldlevelstart = 99
			vim.opt.foldenable = true
			
			-- Убираем точки в fold тексте
			vim.opt.fillchars:append("fold: ")
			
			-- Folding keymaps
			vim.keymap.set("n", "<space>", "za", { desc = "Toggle fold" })
			vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
			vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
			vim.keymap.set("n", "zr", "zr", { desc = "Open folds recursively" })
			vim.keymap.set("n", "zm", "zm", { desc = "Close folds recursively" })
			
			-- Дополнительные полезные маппинги для методов
			vim.keymap.set("n", "z1", ":set foldlevel=1<CR>", { desc = "Fold level 1 (methods)" })
			vim.keymap.set("n", "z2", ":set foldlevel=2<CR>", { desc = "Fold level 2" })
			vim.keymap.set("n", "z3", ":set foldlevel=3<CR>", { desc = "Fold level 3" })
			
			-- Автокоманда для Ruby файлов (опционально)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "ruby", "javascript", "typescript", "go" },
				callback = function()
					vim.opt_local.foldlevel = 99  -- Все открыто при открытии файла
				end,
			})
		end,
	},
}
