local data_path = vim.fn.stdpath("data")
-- local volar_path = data_path .. "/mason/packages/vue-language-server"
local volar_path = data_path .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local make_lsp_opts = function(opts)
  opts = type(opts) == "table" and opts or {}
  local capabilities = opts.capabilities or vim.lsp.protocol.make_client_capabilities()
  -- 添加 nvim-info 的折叠能力
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  opts.capabilities = capabilities
  return opts
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = make_lsp_opts({}),
        eslint = make_lsp_opts({}),
        html = make_lsp_opts({}),
        cssls = make_lsp_opts({}),
        volar = make_lsp_opts({
          on_attach = function(client)
            -- 禁用 volar 的 goto definition 功能
            client.server_capabilities.definitionProvider = false
          end,
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
          settings = {
            vue = {
              updateImportsOnFileMove = { enabled = true },
            },
          },
        }),
        vtsls = make_lsp_opts({
          on_attach = function(client, _)
            client.server_capabilities = vim.tbl_extend("force", client.server_capabilities, {
              workspace = {
                fileOperations = {
                  didRename = {
                    filters = {
                      {
                        pattern = {
                          glob = "**/*.{ts,cts,mts,tsx,js,cjs,mjs,jsx,vue}",
                        },
                      },
                    },
                  },
                },
              },
            })
          end,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = volar_path,
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              -- inlayHints = {
              --   parameterNames = { enabled = "literals" },
              --   parameterTypes = { enabled = true },
              --   variableTypes = { enabled = true },
              --   propertyDeclarationTypes = { enabled = true },
              --   functionLikeReturnTypes = { enabled = true },
              --   enumMemberValues = { enabled = true },
              -- },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              -- inlayHints = {
              --   parameterNames = { enabled = "literals" },
              --   parameterTypes = { enabled = true },
              --   variableTypes = { enabled = true },
              --   propertyDeclarationTypes = { enabled = true },
              --   functionLikeReturnTypes = { enabled = true },
              --   enumMemberValues = { enabled = true },
              -- },
            },
          },
        }),
        -- rust_analyzer 通过 rustup 安装
        rust_analyzer = make_lsp_opts({ mason = false }),
      },
      setup = {
        -- volar 作为 ts_server 插件启动
        volar = function()
          -- return true
        end,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "davidmh/cspell.nvim" },
    opts = function(_, opts)
      local cspell = require("cspell")
      opts.sources = vim.list_extend(opts.sources or {}, {
        cspell.diagnostics.with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
        }),
        cspell.code_actions,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "cspell",
        "stylua",
        "shfmt", -- bash
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function()
      local plugin = require("lazy.core.config").spec.plugins["mason.nvim"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return { ensure_installed = opts.ensure_installed }
    end,
  },
}
