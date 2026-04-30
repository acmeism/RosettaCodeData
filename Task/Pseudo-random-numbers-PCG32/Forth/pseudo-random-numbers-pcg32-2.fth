2variable (s)
2variable (i)
2variable (n)

: pcg32int
  (s) 2@ 2dup 2>r (n) 2@ d* (i) 2@ d+ (s) 2!
  2r@ 18 drshift 2r@ dxor 27 drshift drop 2r> 59 drshift drop
  over over invert 1+ 31 and lshift -rot rshift or
;

: pcg32seed
  0. (s) 2! 0 1 dlshift 1. dor (i) 2!
  pcg32int drop 0 (s) 2@ d+ (s) 2! pcg32int drop
;
