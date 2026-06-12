: signum   \ n -- -1|0|1 ;  \ Integer version
  DUP 0< SWAP 0> - ;   \ True is -1 in Forth

\ Or from Hacker's Delight,

8 CELLS 1- CONSTANT  #shift \ 31 for 32 bit Forth 63 for a 64 bit.

: signum-alt  \ n -- -1|0|1 ;  \ Integer version
  DUP #shift ARSHIFT
  \ ARSHIFT maintains the sign. If top bit was set all its are set, -1.
  SWAP NEGATE #shift RSHIFT OR ;  \ RSHIFT doesn't maintain the sign

: fsignum   \ F: r -- ; -- -1|0|1 ; Leave reslt on the data stack.
  \ Floating point version
  FDUP f0< F0> - ;

