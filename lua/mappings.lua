require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- ===== ターミナル操作の整理 =====
-- 1. ターミナルモードを抜ける（NvChadデフォルトの <C-x> も併用可能）
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- 2. ターミナルモードから直接ウィンドウ移動（抜ける＋移動を1アクションで）
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to below window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to above window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right window" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
