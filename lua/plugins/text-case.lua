return {
  'johmsalas/text-case.nvim',
  config = function()
    require('textcase').setup {}
    require('cmp').setup {
      -- ...
      formatting = {
        fields = { 'abbr', 'menu' },
      },
    }
    require('telescope').load_extension('textcase')
  end,
  keys = {
    'ga',
    { 'ga.', '<cmd>TextCaseOpen<CR>', desc = 'Text case operations' },
    { 'gaa', '<cmd>TextCaseOpen<CR>', desc = 'Text case operations' },
    { 'gac', '<cmd>TextCaseOpen<CR>', mode = 'v', desc = 'Text case operations' },
    { '<Leader>gas', '<cmd>lua require("text-case").current_word("to_snake_case")<CR>', desc = 'To snake_case' },
    { '<Leader>gac', '<cmd>lua require("text-case").current_word("to_camel_case")<CR>', desc = 'To camel_case' },
  },
  cmd = {
    'TextCaseOpen',
    'TextCaseOpenTelescope',
    'TextCaseGo',
    'TextCaseCopy',
  },
  lazy = false,
}
