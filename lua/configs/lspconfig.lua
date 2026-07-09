require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("basedpyright", {
  cmd = {
    "bunx",
    "-p",
    "basedpyright@latest",
    "basedpyright-langserver",
    "--stdio",
  },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

local servers = { "html", "cssls", "basedpyright", "solargraph" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
