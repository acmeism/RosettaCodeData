\ linear interpolation

: lerp ( b2 b1 a2 a1 s -- t )
  fover f-
  frot frot f- f/
  frot frot fswap fover f- frot f*
  f+ ;

: test   11 0 do  0e -1e 10e 0e i s>f lerp f.  loop ;
