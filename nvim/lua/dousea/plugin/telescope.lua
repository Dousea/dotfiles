return function()
  require('telescope').setup {
    pickers = {
      find_files = {
        hidden = true
      },
    },
  }
end
