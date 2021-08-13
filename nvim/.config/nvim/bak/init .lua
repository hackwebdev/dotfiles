-- To setu-- from CLI, for Paq you need: `git clone --depth=1 https://github.com/savq/paq-nvim.git \ "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim`
-- You will need to install language servers `npm i -g vscode-langservers-extracted` and `npm install -g typescript typescript-language-server`
-- If using Mini-map, you'll need to install that with `brew install code-minimap`

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
g.mapleader = " "

-- Plugins
require "paq" {
  "airblade/vim-gitgutter",
  "alvan/vim-closetag",
  "terrortylor/nvim-comment",
  "glepnir/lspsaga.nvim",
  "hoob3rt/lualine.nvim",
  "hrsh7th/nvim-compe",
  "hrsh7th/vim-vsnip",
  "jiangmiao/auto-pairs",
  "kyazdani42/nvim-web-devicons",
  "mhartington/formatter.nvim",
  "neovim/nvim-lspconfig",
  "nvim-lua/lsp-status.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "phaazon/hop.nvim",
  "rmagatti/auto-session",
  "sainnhe/everforest",
  "savq/paq-nvim",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "wellle/targets.vim",
  "kabouzeid/nvim-lspinstall",
  "kyazdani42/nvim-tree.lua",
  "romgrk/barbar.nvim",
  "wfxr/minimap.vim",
  "terryma/vim-multiple-cursors",
  "folke/which-key.nvim"
}

require('nvim_comment').setup()
local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    ["/"] = "Comment", 
    ["e"] = "NvimTreeToggle",
    ["m"] = "Minimap",
    ["n"] = "New File",
    ["a"] = "Select All",
    ["w"] = "Save",
    c ={
        name = "LSP",
        ["f"] = "find",
        ["a"] = "action",
        ["h"] = "hover",
        ["j"] = "scroll up",
        ["k"] = "scroll down",
        ["s"] = "help",
        ["i"] = "diagnostic",
        ["n"] = "jump next",
        ["p"] = "jump previous",
        ["r"] = "rename",
        ["d"] = "preview",
    },
    h = {
        name = "hop",
        ["l"] = "words",
        ["j"] = "lines"
    },
    s = {
        name = "search",
        ["b"] = "buffers",
        ["t"] = "text",
        ["i"] = "git status",
        ["r"] = "registers",
        ["s"] = "spell suggestion",
        ["p"] = "files",
        ["f"] = "browser",
        ["h"] = "help",
    },
  },
})

-- My keymappings
map("n","<leader>e","<cmd>NvimTreeToggle<CR>") 
map("n","<C-r>","<cmd>NvimTreeRefresh<CR>")
  -- CommentToggle
map("n","<leader>/","<cmd>CommentToggle<CR>",{ noremap = true, silent = true })
map("v","<leader>/","<cmd>CommentToggle<CR>",{ noremap = true, silent = true })
  -- better indenting
map("v","<","<gv")
map("v",">",">gv")
  -- move selected lines
map("x","K",":move '<-2<CR>gv-gv")
map("x","J",":move '>+1<CR>gv-gv")
  -- minimap
map("n","<leader>m","<cmd>MinimapToggle<CR>")


-- Hop
require "hop".setup()
map("n", "<leader>hj", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "<leader>hl", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "<leader>hj", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "<leader>hl", "<cmd>lua require'hop'.hint_lines()<cr>")
-- Session
local sessionopts = {
  log_level = "info",
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = nil
}

require("auto-session").setup(sessionopts)

-- LSP this is needed for LSP completions in CSS along with the snippets plugin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits"
  }
}

-- LSP Server config
require "lspconfig".cssls.setup(
  {
    cmd = {"vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
    settings = {
      scss = {
        lint = {
          idSelector = "warning",
          zeroUnits = "warning",
          duplicateProperties = "warning"
        },
        completion = {
          completePropertyWithSemicolon = true,
          triggerPropertyValueCompletion = true
        }
      }
    }
  }
)
require "lspconfig".tsserver.setup {}

-- LSP Prevents inline buffer annotations
vim.lsp.diagnostic.show_line_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false
  }
)
require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.svelte.setup{}
require'lspconfig'.tailwindcss.setup{}
require'lspconfig'.sumneko_lua.setup{}
-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require "lspsaga"

saga.init_lsp_saga()
-- saga.init_lsp_saga {
--   code_action_icon = " ",
--   definition_preview_icon = "  ",
--   dianostic_header_icon = "   ",
--   error_sign = " ",
--   finder_definition_icon = "  ",
--   finder_reference_icon = "  ",
--   hint_sign = "⚡",
--   infor_sign = "",
--   warn_sign = ""
-- }

map("n", "<Leader>cf", ":Lspsaga lsp_finder<CR>", {silent = true})
map("n", "<leader>ca", ":Lspsaga code_action<CR>", {silent = true})
map("v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", {silent = true})
map("n", "<leader>ch", ":Lspsaga hover_doc<CR>", {silent = true})
map("n", "<leader>ck", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', {silent = true})
map("n", "<leader>cj", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', {silent = true})
map("n", "<leader>cs", ":Lspsaga signature_help<CR>", {silent = true})
map("n", "<leader>ci", ":Lspsaga show_line_diagnostics<CR>", {silent = true})
map("n", "<leader>cn", ":Lspsaga diagnostic_jump_next<CR>", {silent = true})
map("n", "<leader>cp", ":Lspsaga diagnostic_jump_prev<CR>", {silent = true})
map("n", "<leader>cr", ":Lspsaga rename<CR>", {silent = true})
map("n", "<leader>cd", ":Lspsaga preview_definition<CR>", {silent = true})

-- Setup treesitter
local ts = require "nvim-treesitter.configs"
ts.setup {ensure_installed = "maintained", highlight = {enable = true}}

-- Colourscheme config
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1
vim.g.everforest_diagnostic_text_highlight = 1
vim.g.everforest_diagnostic_virtual_text = "colored"
vim.g.everforest_current_word = "bold"

-- Load the colorscheme
cmd [[colorscheme everforest]] -- Put your favorite colorscheme here

opt.mouse = "a"
opt.backspace = {"indent", "eol", "start"}
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
opt.signcolumn = "yes" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true

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
require "lualine".setup {
  options = {
    icons_enabled = true,
    theme = "everforest",
    component_separators = {"∙", "∙"},
    section_separators = {"", ""},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {"mode", "paste"},
    lualine_b = {"branch", "diff"},
    lualine_c = {
      {"filename", file_status = true, full_path = true},
      require "lsp-status".status
    },
    lualine_x = {"filetype"},
    lualine_y = {
      {
        "progress"
      }
    },
    lualine_z = {
      {
        "location",
        icon = ""
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- Compe setup start
require "compe".setup {
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
    border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1
  },
  source = {
    -- path = true,
    -- buffer = true,
    -- calc = true,
    -- nvim_lsp = true,
    -- nvim_lua = true,
    -- vsnip = true,
    -- luasnip = true
    path = { kind = "   (Path)" },
    buffer = { kind = "   (Buffer)" },
    calc = { kind = "   (Calc)" },
    vsnip = { kind = "   (Snippet)" },
    nvim_lsp = { kind = "   (LSP)" },
    nvim_lua = false,
    spell = { kind = "   (Spell)" },
    tags = false,
    vim_dadbod_completion = false,
    snippets_nvim = false,
    ultisnips = false,
    treesitter = false,
    emoji = { kind = " ﲃ  (Emoji)", filetypes = { "markdown", "text" } },
  }
}

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
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", {expr = true})
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- End Compe related setup

-- Open nvimrc file
-- map("n", "<Leader>v", "<cmd>e $MYVIMRC<CR>")

-- Source nvimrc file
-- map("n", "<Leader>sv", ":luafile %<CR>")

-- Quick new file
map("n", "<Leader>n", "<cmd>enew<CR>")

-- Easy select all of file
map("n", "<Leader>a", "ggVG<c-$>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Easier file save
map("n", "<Leader>w", "<cmd>:w<CR>")

-- Tab to switch buffers in Normal mode
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

-- Better window movement
map("n", "<C-h>", "<C-w>h", { silent = true } )
map("n", "<C-j>", "<C-w>j", { silent = true } )
map("n", "<C-k>", "<C-w>k", { silent = true } )
map("n", "<C-l>", "<C-w>l", { silent = true } )


--Auto close tags
map("i", ",/", "</<C-X><C-O>")

--After searching, pressing escape stops the highlight
map("n", "<esc>", ":noh<cr><esc>", {silent = true})

-- Telescope Global remapping
local actions = require("telescope.actions")
require("telescope").setup {
  defaults = {
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
      layout_config = {
        width = 0.75,
        prompt_position = "bottom",
        preview_cutoff = 120,
        horizontal = { mirror = false },
        vertical = { mirror = false },
      },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-w>"] = "delete_buffer"
        },
        n = {
          ["<C-w>"] = "delete_buffer"
        }
      }
    }
  }
}

map(
  "n",
  "<leader>sp",
  '<cmd>lua require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>sr", '<cmd>lua require("telescope.builtin").registers()<cr>')
map( 
  "n",
  "<leader>st",
  '<cmd>lua require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>sb", '<cmd>lua require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({}))<cr>')
map("n", "<leader>sh", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map(
  "n",
  "<leader>sf",
  '<cmd>lua require("telescope.builtin").file_browser(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>ss", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>')
map(
  "n",
  "<leader>si",
  '<cmd>lua require("telescope.builtin").git_status(require("telescope.themes").get_dropdown({}))<cr>'
)

-------------------- COMMANDS ------------------------------
cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = true}" -- disabled in visual mode

-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote","--no-semi"},
    stdin = true
  }
end



require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = {prettier},
      typescript = {prettier},
      html = {prettier},
      css = {prettier},
      scss = {prettier},
      markdown = {prettier},
      svelte = {prettier},
      -- lua = {
        -- function()
          -- return {
            -- exe = "luafmt",
            -- args = {"--indent-count", 2, "--stdin"},
            -- stdin = true
          -- }
        -- end
      -- }
    }
  }
)

-- Runs Formatter on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.svelte,*.ts,*.css,*.scss,*.md,*.html : FormatWrite
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

