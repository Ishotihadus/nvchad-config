local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "isort", "black" },
    ruby = { "rubocop" },
  },

  default_format_opts = {
    timeout_ms = 3000,
  },

  format_on_save = {
    timeout_ms = 3000,
    lsp_fallback = true,
  },

  formatters = {
    rubocop = {
      args = { "--server", "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" }
    }
  }
}

return options
