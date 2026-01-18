local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)




vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',

            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine-main')
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ":TSUpdate",
        init = function()
            local parser_installed = {
                "python",
                "go",
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown_inline",
                "markdown",
            }

            vim.defer_fn(function() require("nvim-treesitter").install(parser_installed) end, 1000)
            require("nvim-treesitter").update()

            -- auto-start highlights & indentation
            vim.api.nvim_create_autocmd("FileType", {
                desc = "User: enable treesitter highlighting",
                callback = function(ctx)
                    -- highlights
                    local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

                    -- indent
                    local noIndent = {}
                    if hasStarted and not vim.list_contains(noIndent, ctx.match) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end
    },
    'theprimeagen/harpoon',
    'tpope/vim-fugitive',
    'mbbill/undotree',
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            {'nvimtools/none-ls.nvim'},
            {'jay-babu/mason-null-ls.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    },
    'github/copilot.vim',


    {
        '0x00-ketsu/autosave.nvim',
        config = function()
            require('autosave').setup {
                -- your configuration comes here
                -- or leave it empty to  the default settings
                -- refer to the configuration section below
            }
        end
    },

    {
        "epwalsh/obsidian.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "/Users/antonmiklis/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal",
                },
                {
                    name = "work",
                    path = "/Users/antonmiklis/Library/Mobile Documents/iCloud~md~obsidian/Documents/work",
                },
            },
        }
    }
}

require('lazy').setup(plugins, {})
