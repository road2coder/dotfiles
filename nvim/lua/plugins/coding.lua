return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      { "kevinhwang91/promise-async", lazy = true },
    },
    config = function()
      -- 一些必要的设置
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })

      -- 显示折叠的总行数
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      local opts = {
        provider_selector = function(_, filetype, buftype)
          if filetype == "vue" then
            return { "treesitter", "indent" }
          end
          local function handleFallbackException(bufnr, err, providerName)
            if type(err) == "string" and err:match("UfoFallbackException") then
              return require("ufo").getFolds(bufnr, providerName)
            else
              return require("promise").reject(err)
            end
          end
          return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
            or function(bufnr)
              return require("ufo")
                .getFolds(bufnr, "lsp")
                :catch(function(err)
                  return handleFallbackException(bufnr, err, "treesitter")
                end)
                :catch(function(err)
                  return handleFallbackException(bufnr, err, "indent")
                end)
            end
        end,
        fold_virt_text_handler = handler,
        close_fold_kinds_for_ft = { default = { "imports" } },
      }
      require("ufo").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    vscode = true,
    keys = {
      {
        "\\c",
        function()
          local fn = require("Comment.api").locked("insert.linewise.eol")
          fn("line")
        end,
        desc = "Comment insert end of line",
      },
    },
    config = function()
      local opts = {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
        find = "",
        find_left = "",
        highlight = "",
        update_n_lines = "",
        suffix_last = "l",
        suffix_next = "n",
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "default" },
    },
  },
}
