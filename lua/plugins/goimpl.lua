return {
	"edolphin-ydf/goimpl.nvim",
	ft = "go",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	config = function()
		require("telescope").load_extension("goimpl")
	end,
}
