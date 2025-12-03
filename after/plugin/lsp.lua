---
-- LSP configuration
---
local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system
require('lspconfig').gleam.setup({})
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})
require('lspconfig').solidity_ls.setup({
    cmd = { "solc", "--lsp", "--base-path", ".", "--include-path", "lib" },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    filetypes = { "solidity" },
    root_dir = vim.loop.cwd,
})

---
-- Autocompletion setup
---
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})


require("mason").setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'pyright', 'ruff', 'rust_analyzer', 'gopls', 'lua_ls', 'emmet_language_server', 'cssls', 'dockerls', 'solidity_ls', 'jsonls'},
    handlers = {
        -- Default handler for other servers
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        -- Custom handler for pyright
        pyright = function()
            require('lspconfig').pyright.setup({
                on_attach = function(client, _)
                    client.server_capabilities.hoverProvider = true
                end,
                capabilities = (function()
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
                    return capabilities
                end)(),
                settings = {
                    python = {
                        analysis = {
                            useLibraryCodeForTypes = true,
                            diagnosticSeverityOverrides = {
                                reportUnusedVariable = "warning",
                            },
                            typeCheckingMode = "off",
                            diagnosticMode = "off",
                        },
                    },
                },
            })
        end,
        -- Custom handler for ruff
        ruff = function()
            require('lspconfig').ruff.setup({
                on_attach = function(client, _)
                    if client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                init_options = {
                    settings = {
                        args = {
                            "--ignore", "F821",
                            "--ignore", "E402",
                            "--ignore", "E722",
                            "--ignore", "E712",
                        },
                    },
                },
            })
        end,
    },
})

require("mason-null-ls").setup({
    ensure_installed = {"goimports"},
    automatic_installation = true,
})


local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.goimports,
    },
})

