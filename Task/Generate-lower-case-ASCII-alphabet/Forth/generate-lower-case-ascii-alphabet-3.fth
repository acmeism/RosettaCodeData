create lalpha    27 chars allot    \ create a string in memory for 26 letters and count byte

: ]lalpha ( index -- addr )              \ index the string like an array (return an address)
          lalpha char+ + ;

\ method 1: fill memory with ascii values using a loop
: fillit ( -- )
         26 0
         do
           [char] a I +            \ calc. the ASCII value, leave on the stack
           I ]lalpha c!            \ store the value on stack in the string at index I
         loop
         26 lalpha c! ;            \ store the count byte at the head of the string


\ method 2: load with a string literal
: Loadit    s" abcdefghijklmnopqrstuvwxyz" lalpha PLACE ;
