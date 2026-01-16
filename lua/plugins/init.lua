return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        -- デフォルトのマッピングを適用
        api.config.mappings.default_on_attach(bufnr)
        -- Ctrl-E を Enter と同じ動作（開く）に変更
        vim.keymap.set("n", "<C-e>", api.node.open.edit, {
          buffer = bufnr,
          desc = "nvim-tree: Open",
          noremap = true,
          silent = true,
          nowait = true,
        })
      end

      return {
        on_attach = on_attach,
        actions = {
          open_file = {
            resize_window = false,  -- ファイルを開いてもウィンドウサイズを変えない
          },
        },
        filters = {
          git_ignored = false, -- デフォルトはtrue
          custom = {
            "^\\.git",
            "^node_modules",
          },
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    lazy = false,
  },
  {
    "tadaa/vimade",
    lazy = false,
    opts = {
      recipe = { "default", { animate = true }},
      fadelevel = 0.2
    }
  },
  {
    "djoshea/vim-autoread",
    lazy = false,
  },
  {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = "~/.local/bin/claude", -- Point to local installation
    },
    config = true,
    keys = {
      -- Your keymaps here
    },
    cmd = { "ClaudeCode" },
  },
  {
    "github/copilot.vim",
    lazy = false,
  }

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
