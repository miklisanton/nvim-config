local gs = require('gitsigns')

-- Reset hunk under cursor (normal) or selected lines (visual)
vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')

-- Navigate between hunks
vim.keymap.set('n', ']c', gs.next_hunk)
vim.keymap.set('n', '[c', gs.prev_hunk)

-- Preview hunk diff inline
vim.keymap.set('n', '<leader>hp', gs.preview_hunk)

-- Change base commit to diff against (e.g. to undo a committed change)
-- Usage: :Gitsigns change_base('HEAD~1')
