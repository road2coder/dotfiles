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
        -- rust_analyzer 通过 rustup 安装
        rust_analyzer = make_lsp_opts({ mason = false }),
        pyright = make_lsp_opts({
          settings = {
            python = {
              -- 使用 python 虚拟环境
              -- TODO: 根据是否存在 .venv 文件夹来动态控制
              pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
            },
          },
        }),
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "davidmh/cspell.nvim" },
    opts = function(_, opts)
      local cspell = require("cspell")
      local config = {
        cspell_config_dirs = { "~/.config/cspell" },
      }
      opts.sources = vim.list_extend(opts.sources or {}, {
        cspell.diagnostics.with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
          config = config,
        }),
        cspell.code_actions.with({ config = config }),
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
}
