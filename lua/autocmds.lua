require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local terminal_group = augroup("TerminalAutoInsert", { clear = true })

autocmd("TermOpen", {
  group = terminal_group,
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    -- ターミナルバッファでノーマルモードからinsertモードに戻るマッピング
    vim.keymap.set("n", "<Esc>", "i", { buffer = true, desc = "Terminal: back to insert mode" })
    vim.keymap.set("n", "<C-c>", "i", { buffer = true, desc = "Terminal: back to insert mode" })
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
