local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files({ hidden = true, no_ignore = true })
end, {})
vim.lsp.buf.code_action()
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>pg', function()
    builtin.live_grep({ additional_args = { "--no-ignore", "--hidden" } })
end)
vim.keymap.set('n', '<leader>pD', function()
    local default = vim.fn.expand('%:p:h')
    local dir = vim.fn.input("Dir > ", default, "dir")
    if dir ~= "" then
        builtin.live_grep({ search_dirs = { dir }, additional_args = { "--no-ignore", "--hidden" } })
    end
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
