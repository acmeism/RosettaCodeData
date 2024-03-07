\ Fibonnacci test
10 :noname ( u xt -- u' ) over 2 < if drop exit then >r 1- dup r@ execute swap 1- r> execute + ; Y execute . 55  ok
\ Factorial test
10 :noname  ( u xt -- u' )  over 2 < if 2drop 1 exit then  over 1- swap execute * ; Y execute . 3628800  ok

\ End of approach.
