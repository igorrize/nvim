return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    config = function()
      require("fff").setup({
        max_results = 100,
        layout = {
          height = 0.8,
          width = 0.8,
          prompt_position = "bottom",
          preview_position = "right",
          preview_size = 0.5,
        },
        frecency = { enabled = true },
        history = { enabled = true },
        grep = {
          smart_case = true,
          modes = { "plain", "regex", "fuzzy" },
        },
      })

      vim.keymap.set("n", "<C-p>", function() require("fff").find_files() end, { desc = "Find files (fff)" })
      vim.keymap.set("n", "<leader>fg", function() require("fff").live_grep() end, { desc = "Live grep (fff)" })
      vim.keymap.set("n", "<leader><leader>", function() require("fff").find_files() end, { desc = "Recent files (fff)" })
      vim.keymap.set("n", "<leader>fc", function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end, { desc = "Search current word (fff)" })
    end,
  },
}
