require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright" }

-- read :h vim.lsp.config for changing options of lsp servers 

vim.lsp.config('pyright', {
  before_init = function(_, config)
    local root = config.root_dir or vim.fn.getcwd()
    local venv_names = { ".venv", "venv", ".virtualenv", "virtualenv" }
    for _, venv_name in ipairs(venv_names) do
      local venv_python = root .. "/" .. venv_name .. "/bin/python"
      if vim.fn.executable(venv_python) == 1 then
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = venv_python
        break
      end
    end
  end,

  init_options = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "Standard",
        }
      }
    }
  }
})

vim.lsp.enable(servers)

vim.opt.updatetime = 1000
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- hover capabilityをサポートするLSPクライアントが存在するか確認
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_hover = false
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/hover") then
        has_hover = true
        break
      end
    end

    if has_hover then
      -- エラーが発生しても静かに失敗させる
      pcall(vim.lsp.buf.hover, { border = "rounded" })
    end
  end,
})

