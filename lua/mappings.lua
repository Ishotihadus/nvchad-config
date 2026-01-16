require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- ターミナルモードで Esc-Esc でノーマルモードに戻る
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ターミナルモードでマウスクリック時にビジュアルモードに入らないようにする
-- 別ウィンドウをクリックした場合はそのウィンドウに移動する
map("t", "<LeftMouse>", function()
  local mouse_win = vim.fn.getmousepos().winid
  local current_win = vim.api.nvim_get_current_win()
  if mouse_win ~= current_win and mouse_win ~= 0 then
    local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
    vim.api.nvim_feedkeys(keys, "x", false)
    vim.api.nvim_set_current_win(mouse_win)
  end
end, { desc = "Handle left click in terminal mode" })
map("t", "<2-LeftMouse>", "<Nop>", { desc = "Disable double click in terminal mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
