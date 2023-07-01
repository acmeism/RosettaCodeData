100000 constant N

: q ( n -- addr ) cells here + ;

: qinit
  1 0 q !
  1 1 q !
  N 2 do
    i i 1- q @ - q @
    i i 2 - q @ - q @
    + i q !
  loop ;

: flips
  ." flips: "
  0 N 1 do
    i q @ i 1- q @ < if 1+ then
  loop . cr ;

: qprint ( n -- )
  0 do i q @ . loop cr ;

qinit
10 qprint
999 q @ . cr
flips
bye
