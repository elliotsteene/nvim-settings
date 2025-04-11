return {
    { "github/copilot.vim", event = "InsertEnter", },
    {
        "olimorris/codecompanion.nvim",
        cmd = "CodeCompanionChat",
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
