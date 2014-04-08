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

## INSTALLATION

Example installation if you use pathogen:

    mkdir -p ~/.vim/bundle/netxval/plugin
    cp nextval.vim  ~/.vim/bundle/netxval/plugin
    vi .vimrc # if you want to modifiy the default keys (C-a/C-x) and add e.g.:
    nmap <silent> <unique> + <Plug>nextvalInc
    nmap <silent> <unique> - <Plug>nextvalDec
