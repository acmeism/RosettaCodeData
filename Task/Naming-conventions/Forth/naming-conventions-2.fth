\ buffer is a word that creates a named memory space and ends in a ':'
: buffer:  ( bytes -- ) create allot ;
hex 100 buffer: mybuffer       \ buffer: creates a new WORD in the dictionary call mybuff

\ if object programming extensions are added to Forth they could look like this
class: myclass <super integer
   m: get  @ ;m      \ create the methods with m: ;m
   m: put  ! ;m
   m: clear  0 swap ! ;m
;class
