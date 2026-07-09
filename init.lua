-- =====================================================================
-- 1. 基本設定とリーダーキーの設定 (プラグイン読み込み前に必須)
-- =====================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- VS Codeの Ctrl + D と同じマルチカーソル挙動を再現
vim.g.multi_cursor_next_key = '<C-d>'
vim.g.multi_cursor_prev_key = '<C-p>'
vim.g.multi_cursor_skip_key = '<C-x>'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.fileformat = 'unix'

vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.opt.wrap = false
vim.opt.title = true
vim.opt.swapfile = false
vim.opt.backup = false

-- =====================================================================
-- 2. プラグインマネージャー (lazy.nvim) の自動インストール
-- =====================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- 3. プラグインの配置と設定
-- =====================================================================
require('lazy').setup({
  -- ★ minuet-ai.nvim (AI補完) ★
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('minuet').setup({
        provider = 'gemini',
        provider_options = {
          gemini = {
            model = 'gemini-1.5-flash',
            stream = true,
            optional = { generationConfig = { maxOutputTokens = 256 } },
          },
        },
      })
    end,
  },

  -- gp.nvim (AIチャット)
  {
    'Robitx/gp.nvim',
    config = function() require('gp').setup({}) end,
  },

  'windwp/nvim-ts-autotag',
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = { sidebars = "transparent", floats = "transparent" },
      })
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("nvim-tree").setup {} end,
  },

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

  -- VS Code風のマルチカーソルを確実に再現する最新プラグイン
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Neovim標準のCtrl+D（スクロール）との衝突を完全に回避するための設定
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',           -- ノーマルモードでCtrl+Dを押すと単語を選択
        ['Find Subword Under'] = '<C-d>',   -- 部分一致でもCtrl+Dで選択
      }
    end
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        local filetype = vim.bo[bufnr].filetype
        local enable_format_languages = { markdown = true, go = true, python = true, elixir = true, heex = true }

        if client.server_capabilities.documentFormattingProvider and enable_format_languages[filetype] then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = false }) end,
          })
        end
      end

      local servers = {
        pyright = {}, rust_analyzer = {}, ts_ls = {}, elixirls = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        emmet_ls = { filetypes = { "css", "html", "javascriptreact", "typescriptreact" } },
        lua_ls = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enable = false } } },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if pcall(require, 'cmp_nvim_lsp') then
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      end
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            lspconfig[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
            }
          end
        }
      }
    end
  },

  -- 補完エンジン (nvim-cmp)
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { "~/.config/nvim/lua/snippets" } })

      cmp.setup {
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'minuet', group_index = 1, priority = 100 },
          { name = 'luasnip' },
        },
        performance = { fetching_timeout = 2000 },
      }
    end
  },

  { 'folke/which-key.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' }, change = { text = '~' }, delete = { text = '_' },
        topdelete = { text = '‾' }, changedelete = { text = '~' },
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  { 'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {} },
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } },
          vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case', '--hidden', '-uu',
          },
        },
      }
    end
  },

  -- ★ Neovim v0.11+ 仕様に完全最適化。古いconfig関数を廃止 ★
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'html', 'css', 'elixir', 'heex' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
    },
  }
}, {})

-- =====================================================================
-- 4. キーマップ (Keymaps) & ユーザー定義コマンド (User Commands)
-- =====================================================================
local local_opts = { noremap = true, silent = true }

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<c-z>", ":u<CR>", local_opts)
vim.keymap.set("n", "<c-y>", ":redo<CR>", local_opts)

vim.keymap.set('n', '<S-h>', '^', local_opts)
vim.keymap.set('n', '<S-l>', '$', local_opts)

-- ノーマルモード用 (For Normal Mode)
vim.keymap.set("n", "<c-z>", ":u<CR>", local_opts)
vim.keymap.set("n", "<c-y>", ":redo<CR>", local_opts)

-- インサートモード用 (For Insert Mode)
vim.keymap.set("i", "<c-z>", "<Cmd>undo<CR>", local_opts)
vim.keymap.set("i", "<c-y>", "<Cmd>redo<CR>", local_opts)

vim.keymap.set("n", "<C-h>", "<C-w>h", local_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", local_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", local_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", local_opts)

vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], local_opts)
vim.keymap.set("i", ",", ",<Space>", local_opts)
vim.keymap.set("n", "<leader>..", ":cd ./..<CR>", local_opts)

vim.keymap.set('n', '<C-e>', ':NvimTreeFocus<CR>', local_opts)
vim.keymap.set('n', '<leader>ff', ':Telescope find_files follow=true no_ignore=true hidden=true<cr>', { desc = "Find Files (Hidden)" })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live Grep' })

vim.keymap.set('n', '<leader>d', vim.lsp.buf.hover, { desc = 'LSP: Hover Definition' })
vim.keymap.set('n', '<leader>w', ':bdelete<CR>', local_opts)

vim.keymap.set('n', '<leader>at', ':GpChatToggle<CR>', { desc = 'AI Chat Toggle' })
vim.keymap.set('v', '<leader>ar', ':GpRewrite<CR>', { desc = 'AI Rewrite Selection' })

vim.keymap.set('i', '<A-y>', '<Cmd>Minuet virtual_text_accept<CR>', local_opts)
vim.keymap.set('i', '<A-n>', '<Cmd>Minuet virtual_text_next<CR>', local_opts)
vim.keymap.set('i', '<A-p>', '<Cmd>Minuet virtual_text_prev<CR>', local_opts)

vim.keymap.set('v', '<', '<gv', local_opts)
vim.keymap.set('v', '>', '>gv', local_opts)
vim.keymap.set('v', '<S-h>', '0', local_opts)
vim.keymap.set('v', '<S-l>', '$', local_opts)
vim.keymap.set('v', '<leader>c', '<gc', { remap = true })

vim.api.nvim_create_user_command("Memo", function() vim.cmd([[split | wincmd j | resize 20 | e ~/memo.md ]]) end, {})
vim.api.nvim_create_user_command("Task", function() vim.cmd([[split | wincmd j | resize 20 | e ~/tasks.md ]]) end, {})
vim.api.nvim_create_user_command("Init", function() vim.cmd("e " .. "~/.config/nvim/init.lua") end, {})
vim.api.nvim_create_user_command("Unix", function() vim.cmd([[:set ff=unix | :%s/\r//g]]) end, {})
vim.api.nvim_create_user_command("T", function(opts) vim.cmd('split | wincmd j | resize 10 | terminal ' .. opts.args) end, { nargs = '*' })

-- =====================================================================
-- 5. 自動コマンド (Autocommands)
-- =====================================================================
local custom_group = vim.api.nvim_create_augroup("CustomGroup", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = custom_group,
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = custom_group,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = custom_group,
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})

