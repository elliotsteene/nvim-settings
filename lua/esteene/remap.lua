local which_key = require("which-key")

local lsp_utils = require("esteene.lsp_utils")

which_key.add({
    { "<leader>ff", ":Telescope find_files<CR>",                                     desc = "Open Telescope find_files" },
    { "<leader>fv", ":vsplit | Telescope find_files<CR>",                            desc = "Vertical split find_files" },
    { "<leader>fs", ":split | Telescope find_files<CR>",                             desc = "Split find_files" },
    { "<leader>fg", ":Telescope live_grep<CR>",                                      desc = "Open Telescope live_grep" },
    { "<leader>t",  ":Today<CR>",                                                    desc = "Open today's notes" },
    { '<C-g>d',     ":lua require('esteene.lsp_utils').goto_definition_split()<CR>", desc = "Go to defintion" },
    { "<leader>rn", ":lua vim.lsp.buf.rename()<CR>",                                 desc = "Rename symbol" },
    { "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>",                            desc = "Code action" },
    { "<C-`>",      "<esc>",                                                         desc = "Exit insert mode",          mode = "i" },
    { "<leader>/",  ":noh<CR>",                                                      desc = "Clear search highlight" },
    { "<leader>tn", ":tabnew<CR>",                                                   desc = "Create new tab buffer" },
    { "<leader>cn", ":CodeCompanionChat<CR>",                                        desc = "New Chat Buffer" },
    { "<C-j>",      "<Plug>(copilot-accept-line)",                                   desc = "Accept Copilot suggestion", mode = "i" },
})
