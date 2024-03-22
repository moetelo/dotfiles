local think = require('config.think')
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set('n', '<CR>', think.md.toggle_checkbox)

-- stylua: ignore
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\\\')<CR><CR>')

