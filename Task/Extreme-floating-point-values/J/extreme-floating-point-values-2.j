   (1 % 0) , (_1 % 0)
_ __
   (1e234 * 1e234) , (_1e234 * 1e234)
_ __
   _ + __         NB. generates NaN error, rather than NaN
|NaN error
|   _    +__

   _ - _          NB. generates NaN error, rather than NaN
|NaN error
|   _    -_
   %_
0
  %__             NB. Under the covers, the reciprocal of NegInf produces NegZero, but this fact isn't exposed to the user, who just sees zero
0
