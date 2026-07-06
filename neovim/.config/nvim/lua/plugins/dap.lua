return {
  {
    "mfussenegger/nvim-dap"
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    config = function()
      require("dap-python").setup("python")
    end
  }
}
