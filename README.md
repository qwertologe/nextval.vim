nextval.vim
===========

Plugin for vim - Inc-/decrement the current value (bool, int, numeric, hex) with one keystroke

## DESCRIPTION

During editing position your cursor on a boolean, integer, number or hex value and press + or - in normal mode (esc).

## Examples

* switch=false # +/- -> true
* switch=TRUE  # +/- -> FALSE
* int=1 # - -> 0 -1 -2
* num=4.98 # + -> 4.99 5.00
* num=.4 # + -> .5
* hex=0x19 # + -> 0x1a
* hex=ab # + -> ac
* hex=1B07 # -> 1B08
* hex=#9 # + -> a

New variants:

* test5 # int surrounded
* test123test # int surrounded
* True # boolean
* 0xf9 # hex
* 5A3 # tex
* ’ # xml/xhtml
* \x19 # unix, bash
* FFh or 05A3H # intel assembly
* #9 # modulo2
* 16#5A3# # ada/vhdl
* 16r5A3 # smalltalk/algol
* 16#5A7 # postscript/bash
* \u0019 \U00000019 # bash
* #16r4a # common lisp
* &H5A3 or &5a3 # several basic
* 0h5A3 ti series
* U+20AD # unicode
* S=U+9 # integer
* $5A3 # assembly/basic
* H'ABCD' # microchip
* x"5A3" # vhdl
* 8'hFF # verilog
* #x4a # common lisp
* X'5A3' # ibm mainframe


## INSTALLATION

Example installation if you use pathogen:

    mkdir -p ~/.vim/bundle/netxval/plugin
    cp nextval.vim  ~/.vim/bundle/netxval/plugin
    vi .vimrc # if you want to modifiy the default keys (C-a/C-x) and add e.g.:
    nmap <silent> <unique> + <Plug>nextvalInc
    nmap <silent> <unique> - <Plug>nextvalDec
