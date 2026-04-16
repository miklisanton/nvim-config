-- LSP configuration
local function to_snake(s)
  -- SCREAMING_SNAKE or already_snake: contains _ but no lowercase→uppercase transition
  if s:find('[_]') and not s:find('%l%u') then
    return s:lower()
  end
  -- camelCase / PascalCase: split on lowercase→uppercase boundary
  return s:gsub('(%l)(%u)', function(a, b) return a .. '_' .. b end)
          :gsub('[-. ]', '_')
          :lower()
end

local function case_variants(s)
  local snake  = to_snake(s)
  local camel  = snake:gsub('_(%a)', string.upper)
  local pascal = camel:sub(1,1):upper() .. camel:sub(2)
  return {
    { label = 'snake_case',      value = snake },
    { label = 'camelCase',       value = camel },
    { label = 'PascalCase',      value = pascal },
    { label = 'SCREAMING_SNAKE', value = snake:upper() },
  }
end

local function case_rename()
  local word = vim.fn.expand('<cword>')
  vim.ui.select(case_variants(word), {
    prompt = 'Rename "' .. word .. '" to:',
    format_item = function(item) return item.label .. '  →  ' .. item.value end,
  }, function(choice)
    if choice then vim.lsp.buf.rename(choice.value) end
  end)
end

local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', '<leader>ri', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set('n', '<leader>rc', case_rename, opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

-- TYPESCRIPT
local vue_language_server_path = vim.fn.stdpath("data") .. '/mason/packages/vue-language-server/node_modules/@vue/language-server';
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config('ts_ls', {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
vim.lsp.config('vue_ls', {
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
vim.lsp.enable({'ts_ls', 'vue_ls'})

-- PYTHON
vim.lsp.config('pyright', {
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
vim.lsp.config('ruff', {
  -- pyproject.toml / ruff.toml checked before .git so monorepos work
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  on_attach = function(client, bufnr)
    lsp_attach(client, bufnr)
  end,
})
-- JAVA (jdtls needs per-project workspace dir — use FileType autocmd)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local workspace = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project
    vim.lsp.start({
      name = 'jdtls',
      cmd = { 'jdtls', '-data', workspace },
      root_dir = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' }),
      on_attach = lsp_attach,
    })
  end,
})
-- GO
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
require("mason-null-ls").setup({ ensure_installed = {"goimports", "mypy", "prettier"} })
local null_ls = require("null-ls")
null_ls.setup({ sources = {
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
  null_ls.builtins.formatting.prettier.with({
    filetypes = { "javascript", "typescript", "vue", "css", "html", "json", "yaml", "markdown" },
  }),
} })
-- Enable all configured servers
vim.lsp.enable({ 'vue_ls', 'ts_ls', 'pyright', 'ruff', 'rust_analyzer', 'gopls', 'lua_ls', 'emmet_language_server', 'cssls', 'dockerls', 'solidity_ls', 'jsonls' })

