local M = {
	"nvim-telescope/telescope.nvim",
  dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
	lazy = true,
	cmd = "Telescope",
}

function M.config()
  local actions = require "telescope.actions"
    -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')


   require("telescope").setup({
      extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },

      defaults = {
         mappings = {
            i = {
               ["<C-j>"] = actions.move_selection_next,
               ["<C-k>"] = actions.move_selection_previous,
               ["<C-q>"] = actions.close,
               ["<C-n>"] = actions.cycle_history_next,
               ["<C-p>"] = actions.cycle_history_prev
            },

            n = {
               ["j"] = actions.move_selection_next,
               ["k"] = actions.move_selection_previous,
               ["q"] = actions.close,
               ["n"] = actions.cycle_history_next,
               ["p"] = actions.cycle_history_prev
            }
         }
      }
   })

end

return M
