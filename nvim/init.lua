-- Базовый конфиг Neovim
-- Тема: black-metal-theme-neovim (github.com/metalelf0/black-metal-theme-neovim)

-- Опции
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"

-- Лидер
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Тема: замени на "bathory-alt", "darkthrone", "mayhem", "windir"...
-- Варианты: <band>, <band>-alt (светлее фон), <band>-light (светлая тема)
vim.cmd.colorscheme("bathory")

-- Горячие клавиши
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Сохранить" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Выход" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Проводник" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Снять подсветку поиска" })
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
