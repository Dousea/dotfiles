local default_opts = { noremap = true, silent = true }

-- Better indent
vim.keymap.set("v", "<", "<gv", default_opts)
vim.keymap.set("v", ">", ">gv", default_opts)

-- Paste over currently selected text without yanking it
vim.keymap.set("v", "p", '"_dP', default_opts)

-- Center search results
vim.keymap.set("n", "n", "nzz", default_opts)
vim.keymap.set("n", "N", "Nzz", default_opts)

-- Move lines
vim.keymap.set("n", "C-A-j", ":m .+1<CR>==", default_opts)
vim.keymap.set("n", "C-A-k", ":m .-2<CR>==", default_opts)
vim.keymap.set("i", "C-A-j", "<Esc>:m .+1<CR>==gi", default_opts)
vim.keymap.set("i", "C-A-k", "<Esc>:m .-2<CR>==gi", default_opts)
vim.keymap.set("v", "C-A-j", ":m '>+1<CR>gv=gv", default_opts)
vim.keymap.set("v", "C-A-k", ":m '<-2<CR>gv=gv", default_opts)

