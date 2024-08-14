-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim

local is_proxy_set = vim.env.https_proxy ~= nil or vim.env.http_proxy ~= nil

return {
    { "rcarriga/nvim-notify", enabled = false },
    { "folke/todo-comments.nvim", enabled = false },

    { 'copilot-cmp', enabled = is_proxy_set },
    {
        'neanias/everforest-nvim',
        config = function()
            require('everforest').setup({
                transparent_background_level = 2,
            })
        end,
    },

    {
        'LazyVim/LazyVim',
        opts = {
            colorscheme = 'everforest',
        },
    },

    {
        'akinsho/bufferline.nvim',
        keys = {
            { '<Tab>', '<cmd>BufferLineCycleNext<cr>' },
            { '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>' },
        },
    },

    {
        'folke/noice.nvim',
        opts = {
            cmdline = {
                view = 'cmdline',
            },

            messages = {
                view = 'mini',
            },
        },
    },

    {
        'wakatime/vim-wakatime',
        lazy = false,
    },

    {
        'nvim-telescope/telescope.nvim',
        keys = {
            { '<leader>fw', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
        },
        opts = {
            defaults = {
                layout_strategy = 'horizontal',
                layout_config = { prompt_position = 'top' },
                sorting_strategy = 'ascending',
                winblend = 0,
            },
        },
    },

    {
        'neovim/nvim-lspconfig',
        ---@class PluginLspOpts
        opts = {
            inlay_hints = { enabled = false },

            ---@type lspconfig.options
            servers = {
                pyright = {},
                twiggy_language_server = {
                  settings = {
                    twiggy = {
                      framework = 'symfony',
                      phpExecutable = 'php-legacy',
                      symfonyConsolePath = 'bin/console',
                    },
                  },
                },
                volar = {},
                html = {},
                cssls = {},
            },
            -- setup = function()
            --     require('lspconfig').volar.setup({})
            -- end,
        },
    },

    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    -- { import = 'lazyvim.plugins.extras.lang.typescript' },

    -- add more treesitter parsers
    {
        'nvim-treesitter/nvim-treesitter',
        opts = {
            ensure_installed = {
                'bash',
                'html',
                'javascript',
                'json',
                'lua',
                'markdown',
                'markdown_inline',
                'python',
                'query',
                'regex',
                'tsx',
                'typescript',
                'vim',
                'yaml',
                'twig',
                'vue',
                'scss',
            },
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
    },

    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {
                'stylua',
                'shellcheck',
                'shfmt',
                'flake8',
            },
        },
    },

    -- then: setup supertab in cmp
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-emoji',
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                local unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            local cmp = require('cmp')

            opts.mapping = vim.tbl_extend('force', opts.mapping, {
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            })
        end,
    },
}
