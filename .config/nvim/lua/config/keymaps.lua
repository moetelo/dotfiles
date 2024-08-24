local think = require('config.think')
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Default: joins lines
vim.keymap.set('n', 'J', '<Nop>')

vim.keymap.set('n', '<CR>', think.md.toggle_checkbox)

-- search selected by tapping //
-- stylua: ignore
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\\\')<CR><CR>')

vim.keymap.set('n', '<C-ы>', '<cmd> w <CR>')
vim.keymap.set('i', '<C-ы>', '<ESC><cmd> w <CR>')

