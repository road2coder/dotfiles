return {
  {
    "hrsh7th/nvim-cmp",
    event = "BufReadPost",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    config = function(_, opts)
      -- LazyVim default config function
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local parse = require("cmp.utils.snippet").parse
      require("cmp.utils.snippet").parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
          return ret
        end
        return LazyVim.cmp.snippet_preview(input)
      end

      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.event:on("confirm_done", function(event)
        if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          LazyVim.cmp.auto_brackets(event.entry)
        end
      end)
      cmp.event:on("menu_opened", function(event)
        LazyVim.cmp.add_missing_snippet_docs(event.window)
      end)

      -- 搜索补全
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- 命令补全
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
}
