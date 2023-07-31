-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

vim.g.mapleader = ' '
vim.g.localleader = ' '

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- ui
  use { 'morhetz/gruvbox', config = function () vim.cmd('colorscheme gruvbox') end }

  -- telescope
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          path_display = { "shorten" },
          file_ignore_patterns = {"node_modules", "target", "dist"},
          mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false, } }
        }
      }
      pcall(require('telescope').load_extension, 'fzf')
    end
  }

  -- edit
  use {
    'ntpeters/vim-better-whitespace',
    config = function ()
      vim.g.better_whitespace_enabled = 0
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
    end
  }
  use { 'vimwiki/vimwiki', config = function ()
    local wiki_home =  "~/wiki"
    vim.cmd([[
      let wiki = { 'name': 'wiki', 'path': '~/wiki', 'auto_toc': 1, 'syntax': 'markdown', 'ext': 'md' }
      let g:vimwiki_list = [wiki]
      let g:vimwiki_html_header_numbering = 1
      let g:vimwiki_markdown_link_ext = 1
    ]])
    vim.keymap.set('n', '<leader>p', function () require('telescope.builtin').find_files({ prompt_title = "< Wiki >", cwd = wiki_home }) end, { desc = 'Search Wiki' })
    vim.keymap.set('n', '<leader>g', function () require('telescope.builtin').live_grep({ prompt_title = "< Search In Wiki >", cwd = wiki_home }) end, { desc = 'Grep Wiki Content'})
    end
  }

  -- git
  use {
    'tpope/vim-fugitive',
    config = function ()
      vim.keymap.set('n', '<Leader>gs', ':Git<CR>', { noremap = true })
    end
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })

vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>m', ':on<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>ev', ':sp $MYVIMRC<CR>:lcd %:h<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>sv', ':source $MYVIMRC<CR>', { noremap = true })

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true

vim.opt.clipboard = { 'unnamedplus' }

vim.opt.undofile = true

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Tab
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Statusline
vim.cmd([[
  set statusline=%f%m%r%w\ %{fugitive#statusline()}\ [POS+%04l,%04v]\ [%p%%]\ [LEN=%L]\ [%{&ff}]
]])

vim.keymap.set('n', 'gV', '`[v`]', { noremap = true })

