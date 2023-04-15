-- General Settings {{{

-- Leader
vim.g.mapleader = " "

-- Dsiable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Window settings 
vim.opt.title = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmode = false


-- Spelling
vim.opt.spelllang = 'en'

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Buffer
vim.opt.number = true
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.showmode = false

-- Mouse
vim.opt.mouse = 'n'

-- Swap
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Indent
vim.opt.autoindent = true
vim.opt.copyindent = true

-- diff
table.insert(vim.opt.diffopt, "filter")

-- Wildcard
vim.opt.wildmenu = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.magic = true
table.insert(vim.opt.matchpairs, "<:>")
table.insert(vim.opt.path, "**")
vim.opt.matchtime = 2
vim.opt.showmatch = true
vim.opt.smartcase = true

-- Ignore
vim.opt.wildignore = {
    "*.class",
    "*.gem",
    "*.o",
    "*.obj",
    "*.out",
    "*.rar",
    "*.rbc",
    "*.rbo",
    "*.swp",
    "*.tar.bz2",
    "*.tar.gz",
    "*.tar.xz",
    "*.zip",
    "*/.bundle/*",
    "*/.kitchen/*",
    "*/.sass-cache/*",
    "*/.vagrant/*",
    "*/node_modules/*",
    "*/tmp/cache/assets/*/sass/*",
    "*/tmp/cache/assets/*/sprockets/*",
    "*/tmp/librarian/*",
    "*/vendor/cache/*",
    "*/vendor/cookbooks/*",
    "*/vendor/gems/*",
    "*~",
    "._*",
    ".git",
    ".svn",
}

-- show result of command as you go
vim.opt.inccommand = 'nosplit'

-- list chars

-- undo

--- }}}

-- Mappings {{{

vim.keymap.set('n', '<space>', '<nop>')
-- alternate insert escape
vim.keymap.set('i', 'jj', '<ESC>')

-- Centre half-page movements
vim.keymap.set('n', '<C-U>', '<C-U>zz')
vim.keymap.set('n', '<C-D>', '<C-D>zz')

-- stay in visual mode when indenting
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- terminal mappings
vim.keymap.set('t', '<ESC>', "<C-\\><C-n>")

-- pane navigation
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- panel navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Keep search pattern at the center of the screen
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
vim.keymap.set('n', 'g#', 'g#zz', { silent = true })

-- clear hlsearch
vim.keymap.set('n', '<leader>/', ':let @/=""<CR>')

-- lazy write
vim.keymap.set('n', '<leader>w', ':w<CR>')

-- yank to end of line
vim.keymap.set('n', 'Y', 'y$')
-- }}}

-- autocmd {{{

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function(args)
     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', false)
  end
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function(args)
    vim.opt_local.number = false
  end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "term://*",
  callback = function(args)
    vim.cmd('startinsert')
  end
})

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "term://*",
  callback = function(args)
    vim.cmd('startinsert')
  end
})

-- }}}

-- Search {{{


-- }}}
-- vim: set sw=2 ts=2 ft=lua expandtab fdm=marker fmr={{{,}}} fdl=0 fdls=-1:
