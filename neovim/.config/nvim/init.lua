vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.keymap.set("i", "jk", "<Esc>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local result = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to install lazy.nvim:\n", "ErrorMsg" },
            { result, "WarningMsg" },
        }, true, {})
        return
    end
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins")
