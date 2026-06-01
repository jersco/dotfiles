vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
  { src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine" },
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
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

local fzf = require("fzf-lua")

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      "lsp_status",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

fzf.setup({
  "default",
  fzf_opts = {
    ["--layout"] = "reverse",
  },
  files = {
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!**/.git/*'",
  },
  winopts = {
    height = 0.85,
    width = 0.9,
    preview = {
      layout = "flex",
    },
  },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "gd", fzf.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gr", fzf.lsp_references, vim.tbl_extend("force", opts, { desc = "Find references" }))
    vim.keymap.set("n", "gI", fzf.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gy", fzf.lsp_typedefs, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<leader>ld", fzf.diagnostics_document, vim.tbl_extend("force", opts, { desc = "Document diagnostics" }))
    vim.keymap.set("n", "<leader>lD", fzf.diagnostics_workspace, vim.tbl_extend("force", opts, { desc = "Workspace diagnostics" }))
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})

local servers = {
  lua_ls = "lua-language-server",
  pyright = "pyright-langserver",
  ts_ls = "typescript-language-server",
  zls = "zls",
}

for server, executable in pairs(servers) do
  if vim.fn.executable(executable) == 1 then
    vim.lsp.enable(server)
  end
end

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("i", "kj", "<esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Lexplore<cr>", { desc = "Toggle side explorer" })
vim.keymap.set("n", "<leader>f", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>g", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>h", fzf.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>r", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "Search current buffer" })
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
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
