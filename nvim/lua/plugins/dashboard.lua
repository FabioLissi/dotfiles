local M = {
  'nvimdev/dashboard-nvim',
  dependencies = {'nvim-tree/nvim-web-devicons'}
}

function M.config()
  require('dashboard').setup {
      event = 'VimEnter',
      theme = 'hyper',
      shortcut_type = 'number',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' Apps',
            group = 'DiagnosticHint',
            action = 'Telescope app',
            key = 'a',
          },
          {
            desc = ' dotfiles',
            group = 'Number',
            action = 'Telescope dotfiles',
            key = 'd',
          },
        },
      },
    }
end

return M