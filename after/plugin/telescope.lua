local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.lsp.buf.code_action()
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>pg', function()
    builtin.live_grep()
end)
-- find where current Vue component is used in templates
vim.keymap.set('n', '<leader>pu', function()
  local name = vim.fn.expand('%:t:r') -- filename without extension
  -- convert PascalCase to kebab-case
  local kebab = name:gsub('(%u)', function(c) return '-' .. c:lower() end):gsub('^%-', '')
  -- search for both forms
  local pattern = '^(?!\\s*(//|<!--)).*\\b(' .. name .. '|' .. kebab .. ')\\b'
  builtin.grep_string({ search = pattern, use_regex = true, additional_args = { '--pcre2' }, prompt_title = 'Usages: ' .. name })
end)
