: sqrt-rem                             ( n -- sqrt rem)
  >r 0 1 begin dup r@ > 0= while 4 * repeat
  begin                                \ find a power of 4 greater than TORS
    dup 1 >                            \ compute while greater than unity
  while
    2/ 2/ swap over over + negate r@ + \ integer divide by 4
    dup 0< if drop 2/ else r> drop >r 2/ over + then swap
  repeat drop r>                       ( sqrt rem)
;

: isqrt-mod sqrt-rem swap ;
