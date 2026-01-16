require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local terminal_group = augroup("TerminalAutoInsert", { clear = true })

-- ターミナルを開いたときに insert モードに入る
autocmd("TermOpen", {
  group = terminal_group,
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- ターミナルバッファに入ったときに insert モードに入る
autocmd("BufEnter", {
  group = terminal_group,
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})
