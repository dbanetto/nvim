-- General Settings {{{
-- Window settings 
vim.opt.title = true
vim.opt.cursorline = true


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
-- }}

-- Swap
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

--- }}}

-- Diff {{
table.insert(vim.opt.diffopt, "filter")
-- }}

-- Search {{{

-- Wildcard
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.magic = true
table.insert(vim.opt.matchpairs, "<:>")
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

-- }}}
-- vim: set sw=2 ts=2 ft=lua expandtab fdm=marker fmr={{{,}}} fdl=0 fdls=-1:
