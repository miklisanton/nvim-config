vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<M-l>', '<Plug>(copilot-accept-line)')


vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})







