2000 cells constant /hamming
create hamming /hamming allot
                   ( n1 n2 n3 n4 n5 n6 n7 -- n3 n4 n5 n6 n1 n2 n8)
: min? >r dup r> min >r 2rot r> ;

: hit?             ( n1 n2 n3 n4 n5 n6 n7 n8 -- n3 n4 n9 n10 n1 n2 n7)
  >r 2dup =        \ compare number with found minimum
  if -rot drop 1+ hamming over cells + @ r@ * rot then
  r> drop >r 2rot r>
;                  \ if so, increment and rotate

: hamming#         ( n1 -- n2)
  1 hamming ! >r   \ set first cell and initialize parms
  0 5 over 3 over 2
  r@ 1 ?do         \ determine minimum and set cell
     dup min? min? min? dup hamming i cells + !
     2 hit? 5 hit? 3 hit? drop
  loop             \ find if minimum equals value
  2drop 2drop 2drop hamming r> 1- cells + @
;                  \ clean up stack and fetch hamming number

: test
  cr 21 1 ?do i . i hamming# . cr loop
  1691 hamming# . cr
;
