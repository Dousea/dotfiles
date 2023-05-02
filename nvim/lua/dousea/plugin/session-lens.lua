return function()
  require('session-lens').setup {
    theme = 'auto',
    previewer = true,
  }
  require("telescope").load_extension("session-lens")
end
