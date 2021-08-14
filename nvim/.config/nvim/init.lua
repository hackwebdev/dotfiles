-- To setu-- from CLI, for Paq you need: `git clone --depth=1 https://github.com/savq/paq-nvim.git \ "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim`
-- You will need to install language servers `npm i -g vscode-langservers-extracted` and `npm install -g typescript typescript-language-server`
-- If using Mini-map, you'll need to install that with `brew install code-minimap`

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
g.mapleader = " "

-- Give me some fenced codeblock goodness
g.markdown_fenced_languages = { "html", "javascript", "typescript", "css", "scss", "lua", "vim", "svelte" }

-- Lightspeed remap
vim.api.nvim_set_keymap("n", "h", "<Plug>Lightspeed_s", {})
vim.api.nvim_set_keymap("n", "H", "<Plug>Lightspeed_S", {})
vim.api.nvim_set_keymap("v", "h", "<Plug>Lightspeed_s", {})
vim.api.nvim_set_keymap("v", "H", "<Plug>Lightspeed_S", {})

-- Plugins
require("paq-nvim")({
  "alvan/vim-closetag",
  "b3nj5m1n/kommentary",
  "ggandor/lightspeed.nvim",
  "glepnir/lspsaga.nvim",
  "hoob3rt/lualine.nvim",
  "hrsh7th/nvim-compe",
  "hrsh7th/vim-vsnip",
  "jiangmiao/auto-pairs",
  "kyazdani42/nvim-web-devicons",
  "lewis6991/gitsigns.nvim",
  "mhartington/formatter.nvim",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "onsails/lspkind-nvim",
  "rmagatti/auto-session",
  "sainnhe/everforest",
  "savq/paq-nvim",
  "tpope/vim-repeat",
  "wellle/targets.vim",
  "wfxr/minimap.vim",
  "winston0410/cmd-parser.nvim",
  "winston0410/range-highlight.nvim",
  "blackCauldron7/surround.nvim",
  "kabouzeid/nvim-lspinstall",
  "kyazdani42/nvim-tree.lua",
  "romgrk/barbar.nvim",
  "terryma/vim-multiple-cursors",
  "folke/which-key.nvim"
})



-- Range highlight
require("range-highlight").setup({})
require("surround").setup({})

-- lspkind Icon setup
require("lspkind").init({})
-- gitsigns setup
require("gitsigns").setup({
  numhl = true,
  signcolumn = false,
})



local wk = require("which-key")

wk.register({
  ["/"] = {"<Plug>kommentary_line_default","Comment"},
  ["e"] = {"<cmd>NvimTreeToggle<CR>","NvimTreeToggle"},
  ["r"] = {"<cmd>NvimTreeRefresh<CR>","NvimTreeRefresh"},
  ["m"] = {"<cmd>MinimapToggle<CR>","MinimapToggle"},
  ["n"] = {"<cmd>enew<CR>","New File"},
  ["w"] = {"<cmd>:w<CR>","Save"},
  f = {
    name = "LSP", 
    f = { "<cmd>:Lspsaga lsp_finder<CR><cr>", "Find" },
    a = { "<cmd>:Lspsaga code_action<CR><cr>", "Action" },
    h = { "<cmd>:Lspsaga hover_doc<CR><cr>", "Hover" },
    j = { "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", "Scroll up" },
    k = { "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", "Scroll down" },
    s = { "<cmd>:Lspsaga signature_help<CR><cr>", "Help" },
    i = { "<cmd>:Lspsaga show_line_diagnostics<CR><cr>", "Diagnostic" },
    n = { "<cmd>:Lspsaga diagnostic_jump_next<CR><cr>", "Jump next" },
    p = { "<cmd>:Lspsaga diagnostic_jump_prev<CR><cr>", "Jump previous" },
    r = { "<cmd>:Lspsaga rename<CR><cr>", "Rename" },
    d = { "<cmd>:Lspsaga preview_definition<CR><cr>", "Preview" },
  },
  s = {
    name = "Search", 
    b = { "<cmd>Telescope find_files<cr>", "Find Files" },
    t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
    i = { "<cmd>Telescope git_status<cr>", "Git Status" },
    r = { "<cmd>Telescope registers<cr>", "Registers" },
    s = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggestions" },
    s = { "<cmd>Telescope file_browser<cr>", "Browser" },
    s = { "<cmd>Telescope help_tags<cr>", "Help" },
   }
}, { prefix = "<leader>" })


-- My keymappings
  -- better indenting
map("v","<","<gv")
map("v",">",">gv")
  -- move selected lines
map("x","K",":move '<-2<CR>gv-gv")
map("x","J",":move '>+1<CR>gv-gv")

-- Compe
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", { expr = true })
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- Open nvimrc file
-- map("n", "<Leader>v", "<cmd>e $MYVIMRC<CR>")

-- Source nvimrc file
-- map("n", "<Leader>sv", ":luafile %<CR>")

-- Quick new file
-- map("n", "<Leader>n", "<cmd>enew<CR>")

-- Easy select all of file
-- map("n", "<Leader>sa", "ggVG<c-$>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Easier file save
-- map("n", "<Leader>w", "<cmd>:w<CR>")

-- Tab to switch buffers in Normal mode
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

-- Better window movement
map("n", "<C-h>", "<C-w>h", { silent = true } )
map("n", "<C-j>", "<C-w>j", { silent = true } )
map("n", "<C-k>", "<C-w>k", { silent = true } )
map("n", "<C-l>", "<C-w>l", { silent = true } )

-- More molecular undo of text
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", "!", "!<c-g>u")
-- map("i", "?", "?<c-g>u")
-- map("i", ";", ";<c-g>u")
-- map("i", ":", ":<c-g>u")

-- Keep search results centred
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- Make Y yank to end of the line
map("n", "Y", "y$")

-- Line bubbling
-- Use these two if you don't have prettier
--map('n'), '<c-j>', '<cmd>m .+1<CR>==')
--map('n,) <c-k>', '<cmd>m .-2<CR>==')
-- map("n", "<c-j>", "<cmd>m .+1<CR>", { silent = true })
-- map("n", "<c-k>", "<cmd>m .-2<CR>", { silent = true })
-- map("i", "<c-j> <Esc>", "<cmd>m .+1<CR>==gi", { silent = true })
-- map("i", "<c-k> <Esc>", "<cmd>m .-2<CR>==gi", { silent = true })
-- map("v", "<c-j>", "<cmd>m +1<CR>gv=gv", { silent = true })
-- map("v", "<c-k>", "<cmd>m -2<CR>gv=gv", { silent = true })

-- Simpler increment/decrement integers
map("n", "+", "<C-a>", { silent = true })
map("v", "+", "<C-a>", { silent = true })
map("n", "-", "<C-x>", { silent = true })
map("v", "-", "<C-x>", { silent = true })

--Auto close tags
map("i", ",/", "</<C-X><C-O>")

--After searching, pressing escape stops the highlight
-- map("n", "<esc>", ":noh<cr><esc>", { silent = true })

-- Session
local sessionopts = {
  log_level = "info",
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = nil,
}

require("auto-session").setup(sessionopts)

-- LSP this is needed for LSP completions in CSS along with the snippets plugin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

-- different path for CSS lang server on office machine
local envMachine = os.getenv("MACHINE")
if envMachine == "work" then
  machineCmd =
    "/System/Volumes/Data/usr/local/lib/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server"
else
  machineCmd = "vscode-css-language-server"
end

-- LSP Server config
require("lspconfig").cssls.setup({
  cmd = { machineCmd, "--stdio" },
  capabilities = capabilities,
  settings = {
    scss = {
      lint = {
        idSelector = "warning",
        zeroUnits = "warning",
        duplicateProperties = "warning",
      },
      completion = {
        completePropertyWithSemicolon = true,
        triggerPropertyValueCompletion = true,
      },
    },
  },
})
require("lspconfig").tsserver.setup({})
require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.svelte.setup{}
require'lspconfig'.tailwindcss.setup{}
require'lspconfig'.sumneko_lua.setup{}

-- LSP Prevents inline buffer annotations
vim.lsp.diagnostic.show_line_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_icon = " ",
  definition_preview_icon = "  ",
  dianostic_header_icon = "   ",
  error_sign = " ",
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = "",
})



-- Setup treesitter
local ts = require("nvim-treesitter.configs")
ts.setup({ ensure_installed = "maintained", highlight = { enable = true } })

-- Colourscheme config
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1
vim.g.everforest_diagnostic_text_highlight = 1
vim.g.everforest_diagnostic_virtual_text = "colored"
vim.g.everforest_current_word = "bold"

-- Load the colorscheme
cmd([[colorscheme everforest]]) -- Put your favorite colorscheme here

opt.mouse = "a"
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.encoding = "utf-8" -- Set default encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.foldenable = false
opt.foldmethod = "indent"
opt.formatoptions = "l"
opt.hidden = true
opt.hidden = true -- Enable background buffers
opt.hlsearch = true -- Highlight found searches
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing
opt.joinspaces = false -- No double spaces with join
opt.linebreak = true -- Stop words being broken on wrap
opt.list = false -- Show some invisible characters
opt.number = true -- Show line numbers
opt.numberwidth = 5 -- Make the gutter wider by default
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Don't display mode
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes:1" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true

vim.g.netrw_liststyle = 3 -- Tree style Netrw

-- Use spelling for markdown files ‘]s’ to find next, ‘[s’ for previous, 'z=‘ for suggestions when on one.
-- Source: http:--thejakeharding.com/tutorial/2012/06/13/using-spell-check-in-vim.html
vim.api.nvim_exec(
  [[
augroup markdownSpell
    autocmd!
    autocmd FileType markdown,md,txt setlocal spell
    autocmd BufRead,BufNewFile *.md,*.txt,*.markdown setlocal spell
augroup END
]],
  false
)

-- minimap config
g.minimap_width = 10
g.minimap_auto_start = 0
g.minimap_auto_start_win_enter = 0
-- location icon: 
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "everforest",
    component_separators = { " ", " " },
    section_separators = { "", "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode", "paste" },
    lualine_b = {
      { "branch", icon = "" },
      { "diff", color_added = "#a7c080", color_modified = "#ffdf1b", color_removed = "#ff6666" },
    },
    lualine_c = {
      { "diagnostics", sources = { "nvim_lsp" } },
      function()
        return "%="
      end,
      "filename",
    },
    lualine_x = { "filetype" },
    lualine_y = {
      {
        "progress",
      },
    },
    lualine_z = {
      {
        "location",
        icon = "",
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

-- Compe setup start
require("compe").setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { "", "", "", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    luasnip = true,
  },
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-n>")
  elseif check_back_space() then
    return t("<Tab>")
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t("<C-p>")
  else
    return t("<S-Tab>")
  end
end

-- End Compe related setup



-- Telescope Global remapping
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    winblend = 20,
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-w>"] = "delete_buffer",
        },
        n = {
          ["<C-w>"] = "delete_buffer",
        },
      },
    },
  },
})

-------------------- COMMANDS ------------------------------
cmd("au TextYankPost * lua vim.highlight.on_yank {on_visual = true}") -- disabled in visual mode

-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote" },
    stdin = true,
  }
end

require("formatter").setup({
  logging = false,
  filetype = {
    javascript = { prettier },
    typescript = { prettier },
    html = { prettier },
    css = { prettier },
    scss = { prettier },
    markdown = { prettier },
    svelte = { prettier },
    lua = {
      -- Stylua
      function()
        return {
          exe = "stylua",
          args = { "--indent-width", 2, "--indent-type", "Spaces" },
          stdin = false,
        }
      end,
    },
  },
})

-- Runs Formatter on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.css,*.scss,*.md,*.html,*.lua,*.svelte : FormatWrite
augroup END
]],
  true
)

-- Nvim tree
vim.o.termguicolors = true

g.nvim_tree_side = "left"
g.nvim_tree_width = 30
g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
g.nvim_tree_auto_open = 1
g.nvim_tree_auto_close = 1
g.nvim_tree_quit_on_open = 0
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_root_folder_modifier = ":t"
g.nvim_tree_tab_open = 0
g.nvim_tree_allow_resize = 1
g.nvim_tree_lsp_diagnostics = 1
g.nvim_tree_auto_ignore_ft = { "startify", "dashboard" }

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}

vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "S",
    unmerged = "",
    renamed = "➜",
    deleted = "",
    untracked = "U",
    ignored = "◌",
  },
  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

