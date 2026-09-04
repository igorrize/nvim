return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        auto_attach = false,
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufWritePost" }, {
        callback = function(args)
          local bufnr = args.buf
          if vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= "" then
            require("gitsigns").attach(bufnr)
          end
        end,
      })

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
    end,
  },
}
