-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = false
vim.opt.mouse = ''
vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.api.nvim_set_option("clipboard", "unnamedplus")

-- http://www.lazyvim.org/configuration/tips
vim.api.nvim_create_autocmd({ 'FileType' }, {
    -- pattern = { 'lua' },
    callback = function()
        vim.b.autoformat = false
        vim.opt_local.spell = false
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    pattern = { '*' },
    callback = function()
        vim.cmd('set guicursor=a:ver20-blinkon1')
    end,
})

-- vim.lsp.set_log_level('info')
