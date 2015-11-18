\ generate a string filled with the lowercase ASCII alphabet
\ RAW Forth is quite low level. Strings are simply named memory spaces in Forth.
\ Typically they return an address on the Forth Stack (a pointer) with a count value in CHARs
\ These examples use a string with the first byte containing the length of the string

\ We show 2 ways to load the ASCII values

create lalpha    27 chars allot    \ create a string for 26 letters and count byte

: ]lalpha ( index -- addr )        \ word to index the string like an array
          lalpha char+ + ;

\ method 1: use a loop
: fillit ( -- )
         26 0
         do
           [char] a I +            \ calc. the ASCII value
           I ]lalpha c!            \ store the char (c!) in the string at I
         loop
         26 lalpha c! ;            \ store the count byte at the head of the string


\ method 2: load with a string literal
: Loadit    s" abcdefghijklmnopqrstuvwxyz" lalpha PLACE ;
