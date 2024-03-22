local Think = {
    md = {},
}

Think.md.toggle_checkbox = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()

    if line:find('%[ %]') then
        line = line:gsub('%[ %]', '[x]')
    elseif line:find('%[x%]') then
        line = line:gsub('%[x%]', '[ ]')
    else
        return
    end

    vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], true, { line })
end

return Think
