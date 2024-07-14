local think = require('config.think')
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set('n', '<CR>', think.md.toggle_checkbox)

-- stylua: ignore
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\\\')<CR><CR>')

vim.keymap.set('n', '<Esc>', function()
  vim.cmd 'Noice dismiss'
  vim.cmd 'nohl'
end, { desc = 'Clear notifications and search' })

vim.keymap.set('n', '<C-ы>', '<cmd> w <CR>')
vim.keymap.set('i', '<C-ы>', '<ESC><cmd> w <CR>')

