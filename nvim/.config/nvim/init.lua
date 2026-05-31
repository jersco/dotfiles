vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
}, { confirm = false })

vim.o.termguicolors = true
vim.o.background = "dark"

require("rose-pine").setup({
  variant = "main",
  dark_variant = "main",
  styles = {
    bold = true,
    italic = false,
    transparency = true,
  },
})

vim.cmd.colorscheme("rose-pine")

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.grepprg = "rg --vimgrep --smart-case --hidden --glob '!**/.git/*'"
vim.o.grepformat = "%f:%l:%c:%m"
vim.opt.path:append("**")
vim.opt.wildignore:append({
  "*/.git/*",
  "*/node_modules/*",
  "*/dist/*",
  "*/build/*",
})

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

local function grep(pattern)
  vim.cmd("silent grep! " .. vim.fn.shellescape(pattern))
  vim.cmd("copen")
end

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("i", "kj", "<esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Lexplore<cr>", { desc = "Toggle side explorer" })
vim.keymap.set("n", "<leader>f", ":find ", { desc = "Find file" })
vim.keymap.set("n", "<leader>g", function()
  vim.ui.input({ prompt = "Grep: " }, function(input)
    if input and input ~= "" then
      grep(input)
    end
  end)
end, { desc = "Grep project" })
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

vim.keymap.set("n", "<c-w>h", "<c-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<c-w>j", "<c-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<c-w>k", "<c-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<c-w>l", "<c-w>l", { desc = "Move to right window" })


vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })
vim.keymap.set("n", "<leader>se", "<c-w>=", { desc = "Equalize split sizes" })

vim.keymap.set("n", "<leader>sr", "<cmd>resize +5<cr>", { desc = "Increase split height" })
vim.keymap.set("n", "<leader>sR", "<cmd>resize -5<cr>", { desc = "Decrease split height" })
vim.keymap.set("n", "<leader>sc", "<cmd>vertical resize +10<cr>", { desc = "Increase split width" })
vim.keymap.set("n", "<leader>sC", "<cmd>vertical resize -10<cr>", { desc = "Decrease split width" })
