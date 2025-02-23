return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "wombat",
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          {'filename'},
          {
            'buffers',
            show_filename_only = true,   -- Only show the filename, without the path
            hide_filename_extension = false, -- Show the file extension
            show_modified_status = true, -- Show the modified status
            mode = 2, -- 0: Shows buffer name
                      -- 1: Shows buffer index
                      -- 2: Shows buffer number
            max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                                -- it can also be a function that returns
                                                -- the value of `max_length` dynamically.
            filetype_names = {
              TelescopePrompt = 'Telescope',
              dashboard = 'Dashboard',
              packer = 'Packer',
              fzf = 'FZF',
              alpha = 'Alpha'
            },  -- Shows specific buffer name for that filetype ( { 'filetype': 'buffer name', ... } )
            buffers_color = {
              active = 'lualine_a_normal',     -- Color for active buffer.
              inactive = 'lualine_b_normal',   -- Color for inactive buffer.
            },
            symbols = {
              modified = ' ●',      -- Text to show when the buffer is modified
              alternate_file = '',  -- Text to show to identify the alternate file
              directory =  '',     -- Text to show when the buffer is a directory
            },
          }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    })
  end
}

