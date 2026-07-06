return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.black
        }
      })
    end
  }
}
