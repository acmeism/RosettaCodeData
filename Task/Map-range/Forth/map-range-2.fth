: lerp ( o2 r2 r1 o1 s -- t ) fswap f-  fswap f/  f*  f+ ;

: test   11 0 do  -1e 1e 10e 0e i s>f lerp f.  loop ;
