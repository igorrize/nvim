return {
	{
		"hasansujon786/super-kanban.nvim",
		dependencies = {
			"folke/snacks.nvim", -- [required]
			"nvim-orgmode/orgmode", -- [optional] Org format support
		},
		config = function()
			require("super-kanban").setup({
				markdown = {
					notes_dir = "./tasks/",
					list_heading = "h2",
					default_template = {
						"## Backlog\n",
						"## Todo\n",
						"## Work in progress\n",
						"## Completed\n",
					},
				},
				mappings = {
					["<cr>"] = "open_note",
					["gD"] = "delete_card",
					["<C-t>"] = "toggle_complete",
				},
			})
			
			-- Keymaps for quick access
			vim.keymap.set("n", "<leader>kb", function()
				require("super-kanban").open(nil, true)
			end, { desc = "SuperKanban menu" })

			vim.keymap.set("n", "<leader>ko", function()
				require("super-kanban").open(nil, true)
			end, { desc = "Open Kanban board" })

			vim.keymap.set("n", "<leader>kc", function()
				require("super-kanban").create(nil, true)
			end, { desc = "Create Kanban board" })
		end,
	},
}

