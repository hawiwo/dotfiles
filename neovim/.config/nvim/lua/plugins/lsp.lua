return {
  {
    "williamboman/mason.nvim",
    config = true
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = true
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config("pyright", {})
        vim.lsp.config("ruff", {})
        vim.lsp.enable({ "pyright", "ruff" })
    end
  }
}
