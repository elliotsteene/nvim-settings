return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      -- General
      { "<leader>gk", function() Snacks.picker.keymaps() end,     "Keymaps" },
      { "<c-/>",      function() Snacks.terminal() end,           desc = "Toggle Terminal" },
      -- File
      { "<leader>fe", function() Snacks.explorer() end,           desc = "File explorer" },
      { "<leader>fr", function() Snacks.rename.rename_file() end, desc = "Rename file" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit" },

    },
  },
}
