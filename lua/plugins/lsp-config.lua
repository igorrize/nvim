return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"gopls",
					"solargraph",
					"clojure_lsp",
				},
				automatic_installation = true,
				-- v1 golangci-lint binary vs v2 flags => error spam; don't auto-enable it
				automatic_enable = { exclude = { "golangci_lint_ls" } },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- nvim 0.11+ API (vim.lsp.config/enable). '*' applies to every server.
			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("solargraph", {
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/solargraph", "stdio" },
				settings = {
					solargraph = {
						diagnostics = false,
						rubocop = false,
						formatting = false,
						completion = true,
					},
				},
			})

			vim.lsp.config("clojure_lsp", {
				filetypes = { "clojure", "edn" },
			})

			vim.lsp.config("gopls", {
				-- Workspace mode: root at the umbrella go.work so the modules you add to it get
				-- live cross-module navigation. GOSUMDB override fixes the go1.26.3 toolchain
				-- verify that GOSUMDB=off blocks (GOPRIVATE still bypasses MediDrive repos).
				-- Files in modules NOT in go.work show "not in workspace" until `go work use`.
				cmd_env = {
					GOTOOLCHAIN = "auto",
					GOSUMDB = "sum.golang.org",
				},
				-- prefer the go.work root; fall back to nearest go.mod for standalone modules
				root_markers = { { "go.work" }, { "go.mod" } },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = false,
						gofumpt = true,
					},
				},
			})

			-- lua_ls / pyright / html: auto-enabled by mason-lspconfig with defaults + '*' caps

			-- Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, {})
			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
		end,
	},
}
