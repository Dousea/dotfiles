return function()
  local theme = require('vscode')

  theme.setup {
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = false,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {},

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {}
  }

  theme.load()
end