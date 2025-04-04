return {
  { "github/copilot.vim" },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        strategies = {
          chat = {
            adapter = "copilot"
          },
          inline = {
            adapter = "copilot"
          },
        },
        display = {
          chat = {
            window = {
              position = "right",
            }
          }
        }
      }
    end
  },
}
