return function()
  local telescope = require("telescope")
  local telescope_config = require("telescope.config")

  -- Clone the default Telescope configuration
  local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

  -- I want to search in hidden/dot files.
  table.insert(vimgrep_arguments, "--hidden")
  -- I don't want to search in the `.git` directory.
  table.insert(vimgrep_arguments, "--glob")
  table.insert(vimgrep_arguments, "!**/.git/*")
  -- I want some trimming on the results
  table.insert(vimgrep_arguments, "--trim")

  telescope.setup {
    defaults = {
      -- `hidden = true` is not supported in text grep commands.
      vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
      find_files = {
        -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
  }
end
