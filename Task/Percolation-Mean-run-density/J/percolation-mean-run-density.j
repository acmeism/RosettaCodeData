NB. translation of python

NB.  'N P T' =: 100 0.5 500            NB. silliness

newv =: (> ?@(#&0))~                   NB. generate a random binary vector.  Use:  N newv P
runs =: {: + [: +/ 1 0&E.              NB. add the tail to the sum of 1 0 occurrences  Use: runs V
mean_run_density =: [ %~ [: runs newv  NB. perform experiment.  Use: N mean_run_density P

main =: 3 : 0                          NB.Usage: main T
 T =. y
 smoutput'  T  P    N    P(1-P) SIM   DELTA%'
 for_P. 10 %~ >: +: i. 5 do.
   LIMIT =. (* -.) P
   smoutput ''
   for_N. 2 ^ 10 + +: i. 3 do.
     SIM =. T %~ +/ (N mean_run_density P"_)^:(<T) 0
     smoutput 4 5j2 6 6j3 6j3 4j1 ": T, P, N, LIMIT, SIM, SIM (100 * [`(|@:(- % ]))@.(0 ~: ])) LIMIT
   end.
 end.
 EMPTY
)
