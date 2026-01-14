-- ===== NvChad layout pack (nvchad.term, pos="sp" fixed) =====
-- Layout:
--   Left:  NvimTree (from :NvimTreeOpen), below it keifu terminal
--   Center: main editor, below it terminal
--   Right: :ClaudeCode run last (no capturing)

local M = {}

M.cfg = {
  left_width = 50,            -- request: make tree wider
  left_bottom_height = 64,    -- keifu terminal height
  center_bottom_height = 24,  -- center bottom terminal height
  keifu_cmd = "keifu",
  open_on_start = true,
}

-- ---------- utils ----------
local function safe_cmd(cmd) return pcall(vim.cmd, cmd) end

local function set_width(win, w)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    safe_cmd("vertical resize " .. tostring(w))
    vim.wo.winfixwidth = true
  end
end

local function set_height(win, h)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    safe_cmd("resize " .. tostring(h))
    vim.wo.winfixheight = true
  end
end

local function is_nvimtree_win(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then return false end
  local b = vim.api.nvim_win_get_buf(win)
  return vim.bo[b].filetype == "NvimTree"
end

local function is_terminal_win(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then return false end
  local b = vim.api.nvim_win_get_buf(win)
  return vim.bo[b].buftype == "terminal"
end

local function is_claude_win(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then return false end
  local b = vim.api.nvim_win_get_buf(win)
  local ft = (vim.bo[b].filetype or ""):lower()
  local name = (vim.api.nvim_buf_get_name(b) or ""):lower()
  return ft:find("claude") ~= nil or name:find("claude") ~= nil
end

local function get_term_mod()
  local ok, term = pcall(require, "nvchad.term")
  if not ok then
    vim.notify('require("nvchad.term") failed. This config expects NvChad.', vim.log.levels.ERROR)
    return nil
  end
  return term
end

local function list_wins()
  return vim.api.nvim_tabpage_list_wins(0)
end

local function find_tree_win()
  for _, w in ipairs(list_wins()) do
    if is_nvimtree_win(w) then return w end
  end
  return nil
end

local function find_main_editor_win()
  for _, w in ipairs(list_wins()) do
    if not is_nvimtree_win(w) and not is_terminal_win(w) and not is_claude_win(w) then
      return w
    end
  end
  return nil
end

-- 핵심: "메인 편집 페인"을 반드시 만든다
local function ensure_main_editor_win(tree_win)
  local main = find_main_editor_win()
  if main and vim.api.nvim_win_is_valid(main) then
    return main
  end

  -- tree 밖에 없거나, 전부 특수창뿐이면 우측에 편집창을 만든다
  if tree_win and vim.api.nvim_win_is_valid(tree_win) then
    vim.api.nvim_set_current_win(tree_win)
    vim.cmd("wincmd l") -- try go right
  end

  -- 여전히 한 창뿐이면 vsplit 로 만들기
  if #list_wins() == 1 then
    vim.cmd("vsplit")
  else
    -- tree 옆이 없으면 vsplit
    local cur = vim.api.nvim_get_current_win()
    if tree_win and cur == tree_win then
      vim.cmd("vsplit")
    end
  end

  -- 새 창에서 빈 버퍼 하나
  safe_cmd("enew")
  return vim.api.nvim_get_current_win()
end

-- ---------- actions ----------
local function open_tree()
  if vim.fn.exists(":NvimTreeOpen") ~= 2 then
    vim.notify(":NvimTreeOpen not found.", vim.log.levels.WARN)
    return nil
  end
  pcall(vim.cmd, "NvimTreeOpen")

  local tree = find_tree_win()
  if tree then
    set_width(tree, M.cfg.left_width)
  end
  return tree
end

local function open_keifu_under_tree(term, tree_win)
  if not (tree_win and vim.api.nvim_win_is_valid(tree_win)) then return end
  vim.api.nvim_set_current_win(tree_win)

  -- IMPORTANT: pos="sp" fixed (horizontal split under current window)
  local ok = pcall(term.runner, {
    pos = "sp",
    cmd = M.cfg.keifu_cmd,
    id = "layout_keifu",
    clear_cmd = false,
  })
  if not ok then
    vim.notify('nvchad.term.runner with pos="sp" failed. Check your NvChad term pos options.', vim.log.levels.ERROR)
    return
  end

  -- runner のあと、カレントがターミナル側になる前提で高さ調整
  set_height(vim.api.nvim_get_current_win(), M.cfg.left_bottom_height)

  -- ツリーに戻る
  safe_cmd("wincmd k")
  set_width(tree_win, M.cfg.left_width)
end

local function open_center_bottom_term(term, main_win)
  if not (main_win and vim.api.nvim_win_is_valid(main_win)) then return end
  vim.api.nvim_set_current_win(main_win)

  -- IMPORTANT: pos="sp" fixed (horizontal split under main editor)
  local ok = pcall(term.new, {
    pos = "sp",
    cmd = "",               -- interactive shell
    id = "layout_center",
  })
  if not ok then
    vim.notify('nvchad.term.new with pos="sp" failed. Check your NvChad term pos options.', vim.log.levels.ERROR)
    return
  end

  set_height(vim.api.nvim_get_current_win(), M.cfg.center_bottom_height)

  -- main editor に戻る
  safe_cmd("wincmd k")
end

function M.apply_layout()
  safe_cmd("tabonly")
  safe_cmd("only")
  vim.o.equalalways = false

  local term = get_term_mod()
  if not term then return end

  -- 1) NvimTree を開く（左カラム確定）
  local tree_win = open_tree()

  -- 2) メイン編集ペインを必ず作る（あなたの指摘どおりここが重要）
  local main_win = ensure_main_editor_win(tree_win)

  -- 3) ツリーの下に keifu
  if tree_win then
    open_keifu_under_tree(term, tree_win)
  end

  -- 4) メイン編集の下にターミナル（ここが「真ん中が巨大ターミナル」対策の本丸）
  open_center_bottom_term(term, main_win)

  -- 5) 最後に ClaudeCode（存在するなら）
  if vim.fn.exists(":ClaudeCode") == 2 then
    pcall(vim.cmd, "ClaudeCode")
  end

  -- フォーカスはメイン編集へ
  if main_win and vim.api.nvim_win_is_valid(main_win) then
    vim.api.nvim_set_current_win(main_win)
  end
end

vim.api.nvim_create_user_command("NvCharmLayout", function()
  pcall(M.apply_layout)
end, {})

if M.cfg.open_on_start then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.schedule(function()
        pcall(M.apply_layout)
      end)
    end,
  })
end

return M

