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
          -- 支持python虚拟环境
          on_init = function(client)
            local venv = vim.fs.find(".venv", { path = vim.fn.getcwd(), type = "directory" })[1]
            if venv then
              local exe_file = vim.loop.os_uname().sysname == "Windows_NT" and "/Scripts/python.exe" or "/bin/python"
              local python_path = venv .. exe_file
              if vim.fn.executable(python_path) == 1 then
                client.config.settings.python.pythonPath = python_path
              end
            end
          end,
        }),
        ["*"] = {
          keys = {
            { "<leader>cr", false },
          },
        },
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
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "cspell",
        "stylua",
        "shfmt", -- bash
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>ct", function()
            vim.cmd.RustLsp("testables")
          end, { desc = "Rust Testables", buffer = bufnr })
          vim.keymap.set("n", "<leader>cr", function()
            vim.cmd.RustLsp("runnables")
          end, { desc = "Rust Runnables", buffer = bufnr })
        end,
      },
    },
  },
}
