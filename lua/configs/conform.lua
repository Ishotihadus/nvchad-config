local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
    ruby = { "rubocop" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 10000,
    lsp_fallback = true,
    quiet = false,
  },
}

return options
