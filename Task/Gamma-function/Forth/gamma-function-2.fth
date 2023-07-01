2 constant (gamma-shift)               \ don't change this
                                       \ an approximation of the d(x) function
: ~d(x)                                ( f1 -- f2)
  fdup 10 s>f f<                       \ use first symmetrical sigmoidal
  if                                   \ for range 1-10
    -2705443e-8 fswap 2280802e-6 f/ 1428045e-6 f** 1 s>f f+ f/ 3187831e-8 f+
  else                                 \ use second symmetrical sigmoidal
    -29372563e-9 fswap 1841693e-6 f/ 1052779e-6 f** 1 s>f f+ f/ 3330828e-8 f+
  then 333333333e-10 fover f< if fdrop 1 s>f 30 s>f f/ then
;                                      \ perform some sane clipping to infinity

: (ramanujan)                          ( f1 -- f2)
  fdup fdup f* 4 s>f f*                ( n 4n2)
  fover fover f* fdup f+ f+ fover f+   ( n 8n3+4n2+n)
  fover ~d(x) f+                       ( n 8n3+4n2+n+d[x])
  1 s>f 6 s>f f/ f**                   ( n 8n3+4n2+n+d[x]^1/6)
  fswap fdup 2.7182818284590452353e f/ ( 8n3+4n2+n+d[x]^1/6 n n/e)
  fswap f** f* pi fsqrt f*             ( f)
;

: gamma                                ( f1 -- f2)
  fdup f0< >r fdup f0= r> or abort" Gamma less or equal to zero"
  fdup (gamma-shift) 1- s>f f+ (ramanujan) fswap
  1 s>f (gamma-shift) 0 do fover i s>f f+ f* loop fswap fdrop f/
;
