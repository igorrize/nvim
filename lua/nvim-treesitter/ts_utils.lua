-- Compatibility shim for the `nvim-treesitter.ts_utils` module that existed on
-- the (now archived) `master` branch and was removed on `main`. Reimplemented
-- on top of Neovim core treesitter so plugins still pinned to the old module
-- (e.g. goimpl.nvim) keep working. Resolved via package.path from the config
-- `lua/` dir since `main` ships no such submodule.
local M = {}

function M.get_node_at_cursor(winnr)
	winnr = winnr or 0
	local buf = vim.api.nvim_win_get_buf(winnr)
	local cursor = vim.api.nvim_win_get_cursor(winnr)
	return vim.treesitter.get_node({ bufnr = buf, pos = { cursor[1] - 1, cursor[2] } })
end

function M.get_node_text(node, source)
	return vim.treesitter.get_node_text(node, source or 0)
end

function M.get_node_range(node)
	return node:range()
end

return M
