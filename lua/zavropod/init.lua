-- Set tab width to 2 spaces for JavaScript files
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
  callback = function()
    print("Setting tab width to 2 spaces for JavaScript files")
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"css", "scss", "less"},
  callback = function()
    print("Setting tab width to 2 spaces for css files")
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
