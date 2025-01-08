local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
    ensure_installed = {
      "gopls",
      }
    }
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts) 
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
    { "kevinhwang91/promise-async" },
    },
  },
  {
    "ThePrimeagen/vim-be-good",
  },
  {
    "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = "UIEnter", -- needed for folds to load in time and comments being closed
  keys = {
    { "<leader>if", vim.cmd.UfoInspect, desc = " Fold info" },
    {
      "zm",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = " Close all folds",
    },
    {
      "zr",
      function()
        require("ufo").openFoldsExceptKinds({ "comment", "imports" })
      end,
      desc = " Open regular folds",
    },
    {
      "z1",
      function()
        require("ufo").closeFoldsWith(1)
      end,
      desc = " Close L1 folds",
    },
    {
      "z2",
      function()
        require("ufo").closeFoldsWith(2)
      end,
      desc = " Close L2 folds",
    },
    {
      "z3",
      function()
        require("ufo").closeFoldsWith(3)
      end,
      desc = " Close L3 folds",
    },
    {
      "z4",
      function()
        require("ufo").closeFoldsWith(4)
      end,
      desc = " Close L4 folds",
    },
  },
  init = function()
    -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
    -- auto-closing them after leaving insert mode, however ufo does not seem to
    -- have equivalents for `zr` and `zm` because there is no saved fold level.
    -- Consequently, the vim-internal fold levels need to be disabled by setting
    -- them to 99.
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
  opts = {
    -- when opening the buffer, close these fold kinds
    close_fold_kinds_for_ft = {
      default = { "imports", "comment" },
      json = { "array" },
      markdown = {}, -- avoid everything becoming folded
      -- use `:UfoInspect` to get see available fold kinds
    },
    open_fold_hl_timeout = 800,
    provider_selector = function(_bufnr, ft, _buftype)
      -- ufo accepts only two kinds as priority, see https://github.com/kevinhwang91/nvim-ufo/issues/256
      local lspWithOutFolding = { "markdown", "zsh", "bash", "css", "python", "json" }
      if vim.tbl_contains(lspWithOutFolding, ft) then
        return { "treesitter", "indent" }
      end
      return { "lsp", "indent" }
    end,
    -- show folds with number of folded lines instead of just the icon
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local hlgroup = "NonText"
      local icon = ""
      local newVirtText = {}
      local suffix = ("  %s %d"):format(icon, endLnum - lnum)
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
      table.insert(newVirtText, { suffix, hlgroup })
      return newVirtText
    end,
  },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
        },
        present = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        }
      })
    end
  },
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
    config = function()
      require("screenkey").setup({
        win_opts = {
          row = vim.o.lines - vim.o.cmdheight - 1,
          col = vim.o.columns - 1,
          relative = "editor",
          anchor = "SE", 
          width = 30,
          height = 2,
          border = "single",
          title = "Screenkey",
          title_pos = "center",
          style = "minimal",
          focusable = false,
          noautocmd = true,
        },
        compress_after = 3,
        clear_after = 3,
        disable = {
          filetypes = {},
          buftypes = {},
          events = false,
        },
        show_leader = true,
        group_mappings = false,
        display_infront = {},
        display_behind = {},
        filter = function(keys)
          return keys
        end,
        keys = {
          ["<TAB>"] = "󰌒",
          ["<CR>"] = "󰌑",
          ["<ESC>"] = "Esc",
          ["<SPACE>"] = "␣",
          ["<BS>"] = "󰌥",
          ["<DEL>"] = "Del",
          ["<LEFT>"] = "",
          ["<RIGHT>"] = "",
          ["<UP>"] = "",
          ["<DOWN>"] = "",
          ["<HOME>"] = "Home",
          ["<END>"] = "End",
          ["<PAGEUP>"] = "PgUp",
          ["<PAGEDOWN>"] = "PgDn",
          ["<INSERT>"] = "Ins",
          ["<F1>"] = "󱊫",
          ["<F2>"] = "󱊬",
          ["<F3>"] = "󱊭",
          ["<F4>"] = "󱊮",
          ["<F5>"] = "󱊯",
          ["<F6>"] = "󱊰",
          ["<F7>"] = "󱊱",
          ["<F8>"] = "󱊲",
          ["<F9>"] = "󱊳",
          ["<F10>"] = "󱊴",
          ["<F11>"] = "󱊵",
          ["<F12>"] = "󱊶",
          ["CTRL"] = "Ctrl",
          ["ALT"] = "Alt",
          ["SUPER"] = "󰘳",
          ["<leader>"] = "<leader>",
        }
      })
    end
  },
}
return plugins
