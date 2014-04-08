"
" nextval - Increment/decrement the current value with one keystroke
"
" Copyright (C) 2013 Michael Arlt
"
" Distributed under the GNU General Public License (GPL) 3.0 or higher
" - see http://www.gnu.org/licenses/gpl.html
"

" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

" Version: 1.01
" - Added standard check if already loaded
" - Uses <Plug> for automatic mapping (if not already defined)
"   -> Changed plugin calling - see usage
" - Removed forgotten debug output (sorry)
" - Added buffer awareness
"
" Installation:
" # if you use pathogen:
" mkdir -p ~/.vim/bundle/netxval/plugin
" cp nextval.vim  ~/.vim/bundle/netxval/plugin

" Usage: (e.g. in .vimrc)
" This is the default mapping if you did not define a setting on your own
" nmap <silent> <unique> + <Plug>nextvalInc
" nmap <silent> <unique> - <Plug>nextvalDec
" During editing position your cursor on a boolean, integer, number or
" hex value and press + or - in normal mode (esc).

" check if already loaded
if exists('g:nextval_plugin_loaded')
	finish
endif
let g:nextval_plugin_loaded = 1

" default keymappings
if !hasmapto('<Plug>nextvalInc')
	nmap <silent> <unique> + <Plug>nextvalInc
endif
if !hasmapto('<Plug>nextvalDec')
	nmap <silent> <unique> - <Plug>nextvalDec
endif
" map <Plug> to internal function
nnoremap <unique> <script> <Plug>nextvalInc <SID>nextvalInc
nnoremap <SID>nextvalInc :call <SID>nextval('+')<CR>
nnoremap <unique> <script> <Plug>nextvalDec <SID>nextvalDec
nnoremap <SID>nextvalDec :call <SID>nextval('-')<CR>

" main
function s:nextval(operator)
	if !exists('b:nextval_column')
		" vars to remember last cursor position and determined word-type
		let b:nextval_column = ''
		let b:nextval_line = ''
		let b:nextval_type = ''
		let b:nextval_hexupper = 0
	endif

	if strpart(getline('.'),col('.')-1,1) == '='
		return
	endif

	" remember and adjust settings
	if 'a' == 'A'
		setlocal noignorecase
    let ignorecase=1
  endif
	let iskeyword = &iskeyword   " remember current iskeyword
  silent setlocal iskeyword+=# " enable #XX hex values
	silent setlocal iskeyword+=- " enable negative values

	let word = expand('<cword>')

	" forget type if col/line changed
	if b:nextval_column != col('.') || b:nextval_line != line('.')
		let b:nextval_type = ''
	endif

	" determine type of word (int/hex)
	if matchstr(word,'\([1-9][0-9]*\)\|0') == word
		if b:nextval_type != 'hex'
			let b:nextval_type = 'int'
		endif
	elseif matchstr(word,'[0-9]*\.[0-9]\+') == word
		let b:nextval_type = 'num'
	elseif matchstr(word,'\(0x\|#\)\{0,1}[0-9a-fA-F]\+') == word
		let b:nextval_type = 'hex'
	elseif matchstr(word,'true\|false\c') == word
    let b:nextval_type = 'bool'
	endif

	if b:nextval_type == 'int'
		let newword = a:operator == '+' ? str2nr(word)+1 : str2nr(word)-1
	elseif b:nextval_type == 'num'
		let newword = <SID>nextnum(word,a:operator)
	elseif b:nextval_type == 'hex'
		let newword = <SID>nexthex(word,a:operator)
	elseif b:nextval_type == 'bool'
		let newword = <SID>nextbool(word)
	endif

	if exists('newword')
		execute 'normal ciw' . newword
		execute 'normal wb'
	  let b:nextval_column = col('.')
		let b:nextval_line = line('.')
		"execute ':w'
	endif

	" restore settings
	if exists('ignorecase')
		setlocal ignorecase
	endif
  silent execute 'setlocal iskeyword='.iskeyword
endfunction

" switch boolean value
function s:nextbool(value)
	if a:value == 'false'
		return 'true'
	elseif a:value == 'true'
		return 'false'
	elseif a:value == 'FALSE'
		return 'TRUE'
	elseif a:value == 'TRUE'
		return 'FALSE'
	endif
endfunction

" change numeric value (n; ,n; n,n)
function s:nextnum(value,operator)
	let dotpos = match(a:value,'\.')
	let fractdigits = len(a:value)-dotpos-1
	if a:operator == '+'
		let result = str2float(a:value)+(1/pow(10,fractdigits))
	else
		let result = str2float(a:value)-(1/pow(10,fractdigits))
	endif
	let newnum = printf('%.' . fractdigits . 'f',result)
	if dotpos == 0 && result < 1 && result > 0
		let newnum = strpart(newnum,1)
	endif
	return newnum
endfunction

" change hex value (#X; 0xX; X)
function s:nexthex(value,operator)
	if strpart(a:value,0,2) == '0x'
		let value = strpart(a:value,2)
		let prefix = '0x'
	elseif strpart(a:value,0,1) == '#'
		let value = strpart(a:value,1)
		let prefix = '#'
	else
		let value = a:value
		let prefix = ''
	endif
	let len = len(value)
	let newval = a:operator == '+' ? str2nr(value,16)+1 : str2nr(value,16)-1
	if len(matchstr(value,'[A-F]'))
		let b:nextval_hexupper = 1
	elseif len(matchstr(value,'[a-f]'))
		let b:nextval_hexupper = 0
	endif
	if b:nextval_hexupper
		let newhex = printf('%0' . len . 'X', newval)
	else
		let newhex = printf('%0' . len . 'x', newval)
	endif
	return prefix . newhex
endfunction

