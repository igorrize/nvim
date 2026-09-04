-- Go toolchain fixups for every Go tool nvim spawns (gopls, go.nvim, formatters):
--  1) GOSUMDB=off (surfaced by the launch env) blocks verifying the go1.26.3
--     toolchain; force a working sumdb (GOPRIVATE still bypasses MediDrive repos).
--  2) gopls pins GOTOOLCHAIN=local, so it runs the base go (sdk/go1.26.0) which
--     can't satisfy go.work's `go 1.26.3` -> "initial workspace load failed".
--     Put the already-downloaded 1.26.3 toolchain first on PATH and drop the
--     stale GOROOT so go self-detects. (Durable alt: make sdk/go1.26.3 base in fish.)
vim.env.GOSUMDB = "sum.golang.org"
do
	local cache = vim.trim(vim.fn.system({ "go", "env", "GOMODCACHE" }))
	if vim.v.shell_error == 0 and cache ~= "" then
		local bins = vim.fn.glob(cache .. "/golang.org/toolchain@*-go1.26.3.*/bin", false, true)
		if bins[1] and vim.fn.isdirectory(bins[1]) == 1 then
			vim.env.GOROOT = nil
			vim.env.PATH = bins[1] .. ":" .. (vim.env.PATH or "")
		end
	end
end

-- Node: the shell's nvm default is v14, below the >=18 that telegram.nvim's
-- `npx tsx` backend (and copilot) need. Put the newest installed nvm v22 first
-- on PATH for everything nvim spawns, leaving the shell default alone.
do
	local best, best_key
	for _, dir in ipairs(vim.fn.glob(vim.env.HOME .. "/.nvm/versions/node/v*/bin", false, true)) do
		local maj, min, patch = dir:match("/v(%d+)%.(%d+)%.(%d+)/bin$")
		if maj and tonumber(maj) >= 18 then
			local key = tonumber(maj) * 1e6 + tonumber(min) * 1e3 + tonumber(patch)
			if not best_key or key > best_key then
				best, best_key = dir, key
			end
		end
	end
	if best then
		vim.env.PATH = best .. ":" .. (vim.env.PATH or "")
	end
end

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
	transparent_background = true,
})
local wk = require("which-key")

wk.add({
	{ "<leader>T", group = "telegram" },
	{ "<leader>r", group = "rspec" },
	{ "<leader>rr", ":Neotest run file<CR>", desc = "Run Nearest test in file" },
	{ "<leader>rl", ":Neotest run last<CR>", desc = "Run Last test" },
	{ "<leader>ra", ":Neotest attach<CR>", desc = "Attach Nearest test" },
	{ "<leader>ro", ":Neotest output<CR>", desc = "Neotest output" },
	{ "<leader>rs", ":Neotest summary toggle<CR>", desc = "Neotest summary" },
	{ "<leader>rS", ":Neotest stop<CR>", desc = "Neotest stop" },
	{ "<leader>rp", ":Neotest output-panel toggle<CR>", desc = "Output panel toggle" },
	{ "<leader>rj", group = "jump" },
	{ "<leader>rjn", ":Neotest jump next<CR>", desc = "Jump next" },
	{ "<leader>rjp", ":Neotest jump prev<CR>", desc = "Jump prev" },
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ruby",
	callback = function()
		vim.defer_fn(function()
			vim.diagnostic.enable(false, { bufnr = 0 })
		end, 100)
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	pattern = "*.rb",
	callback = function()
		vim.diagnostic.enable(false, { bufnr = 0 })
	end,
})
