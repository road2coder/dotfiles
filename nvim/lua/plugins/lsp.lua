local data_path = vim.fn.stdpath("data")
local volar_path = data_path .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local tsdk_path = data_path .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"

local make_lsp_opts = function(opts)
  opts = type(opts) == "table" and opts or {}
  local capabilities = vim.lsp.protocol.make_client_capabilities()
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
        eslint = make_lsp_opts({
          mason = false, -- 4.8.0
        }),
        html = make_lsp_opts({}),
        cssls = make_lsp_opts({}),
        volar = make_lsp_opts({
          mason = false, -- 2.0.18
          init_options = {
            vue = {
              hybridMode = false,
            },
            typescript = {
              tsdk = tsdk_path,
            },
          },
        }),
        tsserver = make_lsp_opts({
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = volar_path,
                languages = { "vue" },
              },
            },
          },
        }),
        -- rust_analyzer 通过 rustup 安装
        rust_analyzer = make_lsp_opts({ mason = false }),
      },
      setup = {
        -- volar 作为 ts_server 插件启动
        -- volar = function()
        --   return true
        -- end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
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
