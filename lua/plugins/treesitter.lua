local ensure_installed = {
	"bash", "clojure", "css", "csv", "dockerfile", "embedded_template",
	"func", "git_config", "gitattributes", "gitignore", "go", "gomod",
	"gosum", "gowork", "html", "javascript", "json", "jsonc", "kdl",
	"liquid", "lua", "make", "markdown", "properties", "proto", "robots",
	"ruby", "scss", "slim", "sql", "ssh_config", "templ", "toml", "tsx",
	"typescript", "vim", "vimdoc", "vue", "xml", "yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup()

			local has_cli = vim.fn.executable("tree-sitter") == 1

			local available, installed = {}, {}
			for _, l in ipairs(ts.get_available()) do available[l] = true end
			for _, l in ipairs(ts.get_installed()) do installed[l] = true end

			local missing = {}
			for _, l in ipairs(ensure_installed) do
				if available[l] and not installed[l] then
					missing[#missing + 1] = l
				end
			end
			if has_cli and #missing > 0 then
				ts.install(missing)
			end

			-- Start highlighting + indent per buffer; auto-install unknown but
			-- available parsers on first encounter (replaces auto_install).
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					if not lang then
						return
					end
					if pcall(vim.treesitter.start, ev.buf, lang) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					elseif has_cli and available[lang] and not installed[lang] then
						installed[lang] = true
						ts.install({ lang })
					end
				end,
			})

			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			local select_maps = {
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
			}
			for lhs, query in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end, { desc = "Select " .. query })
			end

			local move_maps = {
				{ "]m", move.goto_next_start, "@function.outer", "Next function start" },
				{ "]c", move.goto_next_start, "@class.outer", "Next class start" },
				{ "]M", move.goto_next_end, "@function.outer", "Next function end" },
				{ "]C", move.goto_next_end, "@class.outer", "Next class end" },
				{ "[m", move.goto_previous_start, "@function.outer", "Prev function start" },
				{ "[c", move.goto_previous_start, "@class.outer", "Prev class start" },
				{ "[M", move.goto_previous_end, "@function.outer", "Prev function end" },
				{ "[C", move.goto_previous_end, "@class.outer", "Prev class end" },
			}
			for _, m in ipairs(move_maps) do
				local lhs, fn, query, desc = m[1], m[2], m[3], m[4]
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					fn(query, "textobjects")
				end, { desc = desc })
			end

			vim.keymap.set("n", "<leader>sp", function()
				swap.swap_next("@parameter.inner", "textobjects")
			end, { desc = "Swap next parameter" })
			vim.keymap.set("n", "<leader>sP", function()
				swap.swap_previous("@parameter.inner", "textobjects")
			end, { desc = "Swap previous parameter" })

			-- Folding: native treesitter foldexpr (replaces nvim_treesitter#foldexpr)
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
			vim.opt.foldenable = true
			vim.opt.fillchars:append("fold: ")

			vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
			vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
			vim.keymap.set("n", "zr", "zr", { desc = "Open folds recursively" })
			vim.keymap.set("n", "zm", "zm", { desc = "Close folds recursively" })
			vim.keymap.set("n", "z1", ":set foldlevel=1<CR>", { desc = "Fold level 1 (methods)" })
			vim.keymap.set("n", "z2", ":set foldlevel=2<CR>", { desc = "Fold level 2" })
			vim.keymap.set("n", "z3", ":set foldlevel=3<CR>", { desc = "Fold level 3" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "ruby", "javascript", "typescript", "go" },
				callback = function()
					vim.opt_local.foldlevel = 99
				end,
			})
		end,
	},
}
