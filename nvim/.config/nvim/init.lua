vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons",               name = "nvim-web-devicons" },
  { src = "https://github.com/ibhagwan/fzf-lua",                          name = "fzf-lua" },
  { src = "https://github.com/nvim-lualine/lualine.nvim",                 name = "lualine" },
  { src = "https://github.com/nvim-mini/mini.completion",                 name = "mini.completion" },
  { src = "https://github.com/nvim-mini/mini.icons",                      name = "mini.icons" },
  { src = "https://github.com/nvim-mini/mini.snippets",                   name = "mini.snippets" },
  { src = "https://github.com/kdheepak/lazygit.nvim",                    name = "lazygit.nvim" },
  { src = "https://github.com/rose-pine/neovim",                          name = "rose-pine" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",           name = "nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig",                     name = "nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim",                      name = "mason" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", name = "mason-tool-installer" },
  { src = "https://github.com/b0o/schemastore.nvim",                      name = "schemastore" },
  { src = "https://github.com/stevearc/oil.nvim",                         name = "oil" },
  { src = "https://github.com/vieitesss/miniharp.nvim",                   name = "miniharp",            version = vim.version.range("v*") },
  { src = "https://github.com/folke/which-key.nvim",                      name = "which-key" },
}, { confirm = false })

vim.o.termguicolors = true
local function system_background()
  if vim.fn.has("mac") ~= 1 then
    return vim.o.background
  end

  local result = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait()
  return result.code == 0 and result.stdout:match("Dark") and "dark" or "light"
end

vim.o.background = system_background()
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.textwidth = 80
vim.o.list = false

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.pumwidth = 35
vim.o.pummaxwidth = 90
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_scaling_factor = 0.9
vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
vim.opt.wildignore:append({
  "*/.git/*",
  "*/node_modules/*",
  "*/dist/*",
  "*/build/*",
})

require("rose-pine").setup({
  variant = "auto",
  dark_variant = "main",
})

vim.cmd.colorscheme("rose-pine")

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local background = system_background()
    if vim.o.background ~= background then
      vim.o.background = background
      vim.cmd.colorscheme("rose-pine")
    end
  end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = vim.highlight.on_yank,
  group = highlight_group,
  pattern = "*",
})

local fzf = require("fzf-lua")
local miniharp = require("miniharp")
local map = vim.keymap.set

require("mini.completion").setup({
  window = {
    info = { border = "rounded" },
    signature = { border = "rounded" },
  },
})

require("mini.icons").setup()

require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_file("~/.config/nvim/snippets/global.json"),
    require("mini.snippets").gen_loader.from_lang(),
  },
})

miniharp.setup({
  autoload = true,
  autosave = true,
  show_on_autoload = false,
  notifications = true,
  ui = {
    position = "center",
    show_hints = true,
    enter = true,
  },
})

require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
  float = {
    border = "rounded",
  },
  confirmation = {
    border = "rounded",
  },
  progress = {
    border = "rounded",
  },
  keymaps_help = {
    border = "rounded",
  },
})

local treesitter = require("nvim-treesitter")

treesitter.setup()

require("which-key").setup({
  spec = {
    { "<leader>c", group = "Code/quickfix" },
    { "<leader>l", group = "LSP" },
    { "<leader>m", group = "miniharp" },
    { "<leader>s", group = "Splits" },
  },
})

local treesitter_parsers = {
  bash = "bash",
  c = "c",
  javascript = "javascript",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  markdown_inline = "markdown_inline",
  odin = "odin",
  python = "python",
  query = "query",
  rust = "rust",
  sh = "bash",
  tsx = "tsx",
  typescript = "typescript",
  vim = "vim",
  vimdoc = "vimdoc",
  yaml = "yaml",
  zig = "zig",
}

local function install_treesitter_parsers()
  pcall(treesitter.install, vim.tbl_values(treesitter_parsers))
end

install_treesitter_parsers()

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(treesitter_parsers),
  callback = function()
    local parser = treesitter_parsers[vim.bo.filetype]

    if parser and not pcall(vim.treesitter.start) then
      pcall(treesitter.install, { parser })
    end
  end,
})

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

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "prettier",
    "tree-sitter-cli",
  },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

local lsp_icons_tweaked = false
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local opts = { buffer = event.buf, silent = true }

    if not lsp_icons_tweaked then
      require("mini.icons").tweak_lsp_kind()
      lsp_icons_tweaked = true
    end

    if vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    local function lsp_map(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    lsp_map("n", "gd", fzf.lsp_definitions, "Go to definition")
    lsp_map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    lsp_map("n", "gr", fzf.lsp_references, "Find references")
    lsp_map("n", "gI", fzf.lsp_implementations, "Go to implementation")
    lsp_map("n", "gy", fzf.lsp_typedefs, "Go to type definition")
    lsp_map("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover documentation")
    lsp_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lsp_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    lsp_map("n", "<leader>ld", fzf.diagnostics_document, "Document diagnostics")
    lsp_map("n", "<leader>lD", fzf.diagnostics_workspace, "Workspace diagnostics")
  end,
})

local formatters_by_filetype = {
  javascript = { "eslint", "ts_ls" },
  javascriptreact = { "eslint", "ts_ls" },
  json = { "jsonls" },
  jsonc = { "jsonls" },
  lua = { "lua_ls" },
  odin = { "ols" },
  rust = { "rust_analyzer" },
  tsx = { "eslint", "ts_ls" },
  typescript = { "eslint", "ts_ls" },
  typescriptreact = { "eslint", "ts_ls" },
  yaml = { "yamlls" },
  yml = { "yamlls" },
  zig = { "zls" },
}

local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  callback = function(event)
    local preferred = formatters_by_filetype[vim.bo[event.buf].filetype]
    if not preferred then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = event.buf, method = "textDocument/formatting" })
    for _, name in ipairs(preferred) do
      for _, client in ipairs(clients) do
        if client.name == name then
          vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 3000 })
          return
        end
      end
    end
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

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

local lsp_tools = {
  eslint = { package = "eslint-lsp", executable = "vscode-eslint-language-server" },
  jsonls = { package = "json-lsp", executable = "vscode-json-language-server" },
  lua_ls = { package = "lua-language-server", executable = "lua-language-server" },
  ols = { package = "ols", executable = "ols" },
  pyright = { package = "pyright", executable = "pyright-langserver" },
  rust_analyzer = { package = "rust-analyzer", executable = "rust-analyzer" },
  ts_ls = { package = "typescript-language-server", executable = "typescript-language-server" },
  yamlls = { package = "yaml-language-server", executable = "yaml-language-server" },
  zls = { package = "zls", executable = "zls" },
}

local lsp_filetypes = {
  javascript = { "ts_ls", "eslint" },
  javascriptreact = { "ts_ls", "eslint" },
  json = { "jsonls" },
  jsonc = { "jsonls" },
  lua = { "lua_ls" },
  odin = { "ols" },
  python = { "pyright" },
  rust = { "rust_analyzer" },
  tsx = { "ts_ls", "eslint" },
  typescript = { "ts_ls", "eslint" },
  typescriptreact = { "ts_ls", "eslint" },
  yaml = { "yamlls" },
  yml = { "yamlls" },
  zig = { "zls" },
}

local function enable_installed_lsp_servers()
  for server, tool in pairs(lsp_tools) do
    if vim.fn.executable(tool.executable) == 1 then
      vim.lsp.enable(server)
    end
  end
end

local installing_lsp_packages = {}

local function start_lsp_server(server, bufnr)
  vim.lsp.enable(server)
end

local function install_lsp_package(server, bufnr)
  local tool = lsp_tools[server]

  if not tool or vim.fn.executable(tool.executable) == 1 then
    start_lsp_server(server, bufnr)
    return
  end

  if installing_lsp_packages[tool.package] then
    return
  end

  installing_lsp_packages[tool.package] = true

  local registry = require("mason-registry")

  registry.refresh(function()
    local ok, package = pcall(registry.get_package, tool.package)

    if not ok then
      installing_lsp_packages[tool.package] = nil
      vim.notify(("Mason package %q was not found for %s"):format(tool.package, server), vim.log.levels.ERROR)
      return
    end

    local installation_failed = false
    package:once("closed", function()
      installing_lsp_packages[tool.package] = nil

      vim.schedule(function()
        if package:is_installed() then
          start_lsp_server(server, bufnr)
        elseif not installation_failed then
          vim.notify(("Mason failed to install %s for %s"):format(tool.package, server), vim.log.levels.ERROR)
        end
      end)
    end)

    package:once("install:failed", function(result)
      installation_failed = true
      vim.schedule(function()
        vim.notify(("Mason failed to install %s: %s"):format(tool.package, tostring(result)), vim.log.levels.ERROR)
      end)
    end)

    if package:is_installed() then
      installing_lsp_packages[tool.package] = nil
      start_lsp_server(server, bufnr)
    else
      vim.notify(("Installing %s for %s via Mason"):format(tool.package, server), vim.log.levels.INFO)
      package:install()
    end
  end)
end

enable_installed_lsp_servers()

vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function()
    enable_installed_lsp_servers()
    install_treesitter_parsers()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(lsp_filetypes),
  callback = function(event)
    for _, server in ipairs(lsp_filetypes[vim.bo[event.buf].filetype] or {}) do
      install_lsp_package(server, event.buf)
    end
  end,
})

local function restart_lsp()
  local bufnr = vim.api.nvim_get_current_buf()

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    client:stop(true)
  end

  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    for _, server in ipairs(lsp_filetypes[vim.bo[bufnr].filetype] or {}) do
      install_lsp_package(server, bufnr)
    end
  end, 100)
end

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("i", "kj", "<esc>", { desc = "Exit insert mode" })
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })
map("n", "<leader>E", "<cmd>Oil --float<cr>", { desc = "Open floating file explorer" })
map("n", "<leader>G", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>f", fzf.files, { desc = "Find files" })
map("n", "<leader>g", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>cw", function()
  fzf.live_grep({ search = vim.fn.expand("<cword>") })
end, { desc = "Search current word" })
map("n", "<leader>b", fzf.buffers, { desc = "Find buffers" })
map("n", "<leader>h", fzf.help_tags, { desc = "Find help" })
map("n", "<leader>r", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Live grep current buffer" })
map("n", "<leader>:", fzf.command_history, { desc = "Command history" })
map("n", "<leader>m", miniharp.toggle_file, { desc = "miniharp: toggle file mark" })
map("n", "<c-n>", miniharp.next, { desc = "miniharp: next file mark" })
map("n", "<c-p>", miniharp.prev, { desc = "miniharp: previous file mark" })
map("n", "<leader>ml", miniharp.show_list, { desc = "miniharp: toggle marks list" })
map("n", "<leader>mL", miniharp.enter_list, { desc = "miniharp: enter marks list" })
for i = 1, 4 do
  map("n", "<leader>" .. i, function()
    miniharp.go_to(i)
  end, { desc = "miniharp: go to mark " .. i })
end
map("i", "<tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<c-n>"
  end
  return "<tab>"
end, { expr = true, desc = "Select completion or insert tab" })
map("i", "<cr>", function()
  if vim.fn.pumvisible() == 1 then
    return "<c-y>"
  end
  return "<cr>"
end, { expr = true, desc = "Accept completion or newline" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>lr", restart_lsp, { desc = "Restart LSP" })
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })
map("n", "<leader>se", "<c-w>=", { desc = "Equalize split sizes" })
map("n", "<leader>sr", "<cmd>resize +5<cr>", { desc = "Increase split height" })
map("n", "<leader>sR", "<cmd>resize -5<cr>", { desc = "Decrease split height" })
map("n", "<leader>sc", "<cmd>vertical resize +10<cr>", { desc = "Increase split width" })
map("n", "<leader>sC", "<cmd>vertical resize -10<cr>", { desc = "Decrease split width" })
