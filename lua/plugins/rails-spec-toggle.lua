return {
      { "HoganMcDonald/rails-rspec-toggle.nvim" },
    },
    {
      "HoganMcDonald/rails-rspec-toggle.nvim",
      keys = {
        {
          "<leader>tt",
          function()
            require("rails-rspec-toggle").toggle()
          end,
          desc = "Toggle rspec test file",
        },
      },
    }
