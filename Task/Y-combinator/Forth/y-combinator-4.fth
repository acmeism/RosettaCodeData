\ Factorial
10 :noname ( u1 xt -- u2 ) over ?dup if 1- swap execute * else 2drop 1 then ;
y execute . 3628800 ok

\ Fibonacci
10 :noname ( u1 xt -- u2 ) over 2 < if drop else >r 1- dup r@ execute swap 1- r> execute + then ;
y execute . 55 ok
