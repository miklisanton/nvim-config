-- LSP configuration
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
-- Configure ts_ls with nvim-lsp-ts-utils
vim.lsp.config('ts_ls', {
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
vim.lsp.config('pyright', {
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
vim.lsp.config('gopls', {
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
-- Other LSP servers
vim.lsp.config('rust_analyzer', {})
vim.lsp.config('emmet_language_server', {
  filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
})
vim.lsp.config('solidity_ls', {
  cmd = { "solc", "--lsp", "--base-path", ".", "--include-path", "lib" },
  filetypes = { "solidity" },
})
-- Completion
local cmp = require('cmp')
cmp.setup({
  sources = {{name = 'nvim_lsp'}},
  snippet = { expand = function(args) vim.snippet.expand(args.body) end },
  mapping = cmp.mapping.preset.insert({}),
})
require("mason").setup()
require("mason-null-ls").setup({ ensure_installed = {"goimports"} })
local null_ls = require("null-ls")
null_ls.setup({ sources = { null_ls.builtins.formatting.goimports } })
-- Enable all configured servers
vim.lsp.enable({ 'ts_ls', 'pyright', 'ruff', 'rust_analyzer', 'gopls', 'lua_ls', 'emmet_language_server', 'cssls', 'dockerls', 'solidity_ls', 'jsonls' })

