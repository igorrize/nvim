return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>bf", ":Neotree filesystem reveal float<CR>", {})
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})

		vim.keymap.set("n", "<leader>y", function()
			local state = require("neo-tree.sources.manager").get_state("filesystem")
			if not state then
				vim.notify("Neo-tree not available")
				return
			end

			local node = state.tree:get_node()
			if not node then
				vim.notify("No file selected")
				return
			end

			local filepath = node.path or node.id
			local relpath = vim.fn.fnamemodify(filepath, ":.")

			vim.fn.setreg("+", relpath)
			vim.notify("Copied: " .. relpath)
		end, { desc = "Copy selected file path from Neo-tree" })
	end,
}
