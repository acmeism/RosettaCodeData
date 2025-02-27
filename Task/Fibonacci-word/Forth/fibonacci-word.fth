: .fibword ( n -- )
  dup case
   0 of drop ." 1" endof
   1 of drop ." 0" endof
   dup 1- recurse
   2 - recurse
  endcase ;

fvariable ilog2
1e 2e fln f/ ilog2 f!

: flog2 ( r -- r )
  fdup f0<> if
    fln ilog2 f@ f*
  then ;

: entropy ( n1 n2 -- r )
  2dup + s>f s>f fover f/ fswap s>f fswap f/
  fdup flog2 f* fswap fdup flog2 f* f+
  fnegate ;

: main
  ."  N    Length Entropy           Word" cr
  1 0
  37 0 do
    i 1+ 2 .r
    2dup + 10 .r space
    2dup entropy 17 15 1 f.rdp space
    i 9 < if i .fibword else ." ..." then
    cr
    tuck +
  loop
  2drop ;

main
bye
