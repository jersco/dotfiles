vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
  { src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
  { src = "https://github.com/dmtrKovalenko/fff.nvim", name = "fff.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim", name = "mason" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", name = "mason-tool-installer" },
  { src = "https://github.com/b0o/schemastore.nvim", name = "schemastore" },
  { src = "https://github.com/stevearc/oil.nvim", name = "oil" },
  { src = "https://github.com/vieitesss/miniharp.nvim", name = "miniharp", version = vim.version.range("v*") },
  { src = "https://github.com/folke/which-key.nvim", name = "which-key" },
}, { confirm = false })

vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

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

vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#6e6a86", bg = "#26233a" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#908caa", bg = "#26233a" })

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.breakindent = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.textwidth = 80
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.o.autocomplete = true
vim.o.autocompletedelay = 0
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.pumwidth = 35
vim.o.pummaxwidth = 90
vim.opt.wildignore:append({
  "*/.git/*",
  "*/node_modules/*",
  "*/dist/*",
  "*/build/*",
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = vim.highlight.on_yank,
  group = highlight_group,
  pattern = "*",
})

local fff = require("fff")
local fzf = require("fzf-lua")
local miniharp = require("miniharp")
local map = vim.keymap.set

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

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

fff.setup({
  lazy_sync = true,
  layout = {
    height = 0.85,
    width = 0.9,
    preview_position = "right",
    preview_size = 0.5,
  },
  grep = {
    modes = { "plain", "regex", "fuzzy" },
    smart_case = true,
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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local opts = { buffer = event.buf, silent = true }

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = event.buf,
            timeout_ms = 3000,
          })
        end,
      })
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
        convert = function(item)
          return {
            abbr = item.label:gsub("%b()", ""),
            kind = item.kind and vim.lsp.protocol.CompletionItemKind[item.kind] or "",
            menu = client.name,
          }
        end,
      })
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
  pyright = { package = "pyright", executable = "pyright-langserver" },
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
  python = { "pyright" },
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

  if vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.cmd, "LspStart " .. server)
  end
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
      return
    end

    package:once("closed", function()
      installing_lsp_packages[tool.package] = nil

      vim.schedule(function()
        start_lsp_server(server, bufnr)
      end)
    end)

    if package:is_installed() then
      installing_lsp_packages[tool.package] = nil
      start_lsp_server(server, bufnr)
    else
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

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("i", "kj", "<esc>", { desc = "Exit insert mode" })
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })
map("n", "<leader>E", "<cmd>Oil --float<cr>", { desc = "Open floating file explorer" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>f", fff.find_files, { desc = "Find files" })
map("n", "<leader>g", fff.live_grep, { desc = "Live grep" })
map("n", "<leader>cw", function()
  fff.live_grep({ query = vim.fn.expand("<cword>") })
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
map("i", "<c-space>", vim.lsp.completion.get, { desc = "Trigger LSP completion" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
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
