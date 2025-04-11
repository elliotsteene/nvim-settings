return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "stevearc/conform.nvim",    event = "BufWritePre" },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "hrsh7th/cmp-buffer",       event = "InsertEnter" },
        { "hrsh7th/cmp-path",         event = "InsertEnter" },
        { "hrsh7th/cmp-cmdline",      event = "CmdlineEnter" },
        { "hrsh7th/nvim-cmp",         event = "InsertEnter" },
        { "L3MON4D3/LuaSnip",         event = "InsertEnter" },
        { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
        { "j-hui/fidget.nvim",        event = "LspAttach" },
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "ruff_fix" },
                go = { "goimports", "gofmt" },
                json = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "pyright",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                        on_init = function(client)
                            local root_dir = client.config.root_dir
                            local venv = root_dir .. "/.venv"
                            if vim.fn.isdirectory(venv) == 1 then
                                client.config.settings.python.pythonPath = venv .. "/bin/python"
                            end
                        end,
                    }
                end,
                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                assist = {
                                    importGranularity = "module",
                                    importPrefix = "by_self",
                                },
                                cargo = {
                                    loadOutDirsFromCheck = true,
                                },
                                procMacro = {
                                    enable = true,
                                },
                                checkOnSave = {
                                    command = "clippy", -- Use clippy for better linting
                                },
                                inlayHints = {
                                    enable = true,
                                    typeHints = {
                                        enable = true,
                                        hideClosureInitialization = false,
                                        hideNamedConstructor = false,
                                    },
                                    parameterHints = {
                                        enable = true,
                                    },
                                    chainingHints = {
                                        enable = true,
                                    },
                                    closingBraceHints = {
                                        enable = true,
                                        minLines = 1,
                                    },
                                    maxLength = 25, -- Maximum length for displayed hints
                                    renderColons = true,
                                },
                            },
                        },
                        on_attach = function(client, bufnr)
                            -- If using Neovim 0.10+, enable inlay hints
                            if vim.lsp.inlay_hint then
                                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                            end
                        end,
                    }
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                analyses = {
                                    unusedparams = true,
                                },
                                staticcheck = true,
                                gofumpt = true,
                                usePlaceholders = true,
                                completeUnimported = true,
                                experimentalPostfixCompletions = true,
                            },
                        },
                        on_attach = function(client, bufnr)
                            -- Add specific key mappings for Go if needed

                            -- Create an autocmd that runs goimports on save
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                pattern = "*.go",
                                callback = function()
                                    local params = vim.lsp.util.make_range_params()
                                    params.context = { only = { "source.organizeImports" } }

                                    -- Synchronously organize imports
                                    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params,
                                        3000)
                                    for _, res in pairs(result or {}) do
                                        for _, r in pairs(res.result or {}) do
                                            if r.edit then
                                                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
                                            else
                                                vim.lsp.buf.execute_command(r.command)
                                            end
                                        end
                                    end

                                    -- Format the buffer
                                    vim.lsp.buf.format({ async = false })
                                end,
                                group = vim.api.nvim_create_augroup("GoImportsFormat", { clear = true }),
                            })
                        end,
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- Navigation within the completion menu
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                -- Confirm selection with Enter
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                -- Keep Ctrl+Space to trigger completion menu (useful in contexts where
                -- completion doesn't automatically appear)
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
