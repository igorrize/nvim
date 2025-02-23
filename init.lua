local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("vim-options")
require("lazy").setup("plugins")
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
		}),
	},
})
require("catppuccin").setup({
  transparent_background = true
})
local wk = require("which-key")

wk.register({
  r = {
    name = "+rspec",
    r = { ":Neotest run file<CR>", "Run Nearest test in file" },
    l = { ":Neotest run last<CR>", "Run Last test" },
    a = { ":Neotest attach<CR>", "Attach Nearest test" },
    o = { ":Neotest output<CR>", "Neotest output" },
    s = { ":Neotest summary toggle<CR>", "Neotest summary" },
    S = { ":Neotest stop<CR>", "Neotest stop" },
    p = { ":Neotest output-panel toggle<CR>", "Output panel toggle" },
    j = {
      name = "+jump",
      n = { ":Neotest jump next<CR>", "Jump next" },
      p = { ":Neotest jump prev<CR>", "Jump prev" },
    },
  },
}, { prefix = "<leader>" })

