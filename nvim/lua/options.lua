require("nvchad.options")

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

o.number = false

local cmd = vim.cmd
local exec = vim.api.nvim_exec
-- highlight on yank
exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=150}
  augroup end
]],
	false
)
-- auto close terminal when process exited
cmd([[autocmd TermClose term://* lua vim.api.nvim_input("<CR>")]])

-- apply filetype for custom files
cmd([[au BufRead,BufNewFile,BufWinEnter */hypr/*.conf set ft=config]])
cmd([[au BufRead,BufNewFile */waybar/config set ft=json]])

-- write on save for MD files
cmd([[autocmd BufNewFile,BufRead *.md :autocmd TextChanged,TextChangedI <buffer> silent write]])

-- do not comment new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])

cmd([[
augroup _env
   autocmd!
   autocmd BufReadPre,FileReadPre,BufEnter .env lua vim.diagnostic.disable(0)
  augroup end
   ]])
