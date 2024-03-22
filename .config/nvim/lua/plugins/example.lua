-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim

local is_proxy_set = vim.env.https_proxy ~= nil or vim.env.http_proxy ~= nil

return {
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

    -- override nvim-cmp and add cmp-emoji
    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-emoji' },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, { name = 'emoji' })
        end,
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

    -- add pyright to lspconfig
    {
        'neovim/nvim-lspconfig',
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                pyright = {},
                twiggy_language_server = {},
                html = {},
                cssls = {},
            },
        },
    },

    -- add tsserver and setup with typescript.nvim instead of lspconfig
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'jose-elias-alvarez/typescript.nvim',
            init = function()
                require('lazyvim.util').lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set('n', '<leader>cR', 'TypescriptRenameFile', { desc = 'Rename File', buffer = buffer })
                end)
            end,
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- tsserver will be automatically installed with mason and loaded with lspconfig
                tsserver = {},
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                tsserver = function(_, opts)
                    require('typescript').setup({ server = opts })
                    return true
                end,
            },
        },
    },

    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    { import = 'lazyvim.plugins.extras.lang.typescript' },

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
            },
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
    },

    -- use mini.starter instead of alpha
    { import = 'lazyvim.plugins.extras.ui.mini-starter' },

    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = 'lazyvim.plugins.extras.lang.json' },

    -- add any tools you want to have installed below
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

    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    -- {
    --     'L3MON4D3/LuaSnip',
    --     keys = function()
    --         return {}
    --     end,
    -- },

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

            local luasnip = require('luasnip')
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
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            })
        end,
    },
}
