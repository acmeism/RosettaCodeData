\ the following functions are commonly native to a Forth system. Shown for completeness

: C+!     ( n addr -- ) dup c@ rot + swap c! ;             \ primitive: increment a byte at addr by n

: +PLACE  ( addr1 length addr2 -- )                        \ Append addr1 length to addr2
          2dup 2>r  count + swap move 2r> c+! ;

: PLACE   ( addr1 len addr2 -- )                           \ addr1 and length, placed at addr2 as counted string
          2dup 2>r  1+  swap  move  2r> c! ;

\ Example begins here
: PREPEND ( addr len addr2 -- addr2)
           >R                                              \ push addr2 to return stack
           PAD PLACE                                       \ place the 1st string in PAD
           R@  count PAD +PLACE                            \ append PAD with addr2 string
           PAD count R@   PLACE                            \ move the whole thing back into addr2
           R> ;                                            \ leave a copy of addr2 on the data stack

: writeln ( addr -- ) cr count type ;                      \ syntax sugar for testing
