   NB.  Temp conversions are all linear polynomials
   K2K    =:     0    1    NB. K = (1  *k) +   0
   K2C    =:  _273    1    NB. C = (1  *k) - 273
   K2F    =:  _459.67 1.8  NB. F = (1.8*k) - 459.67
   K2R    =:     0    1.8  NB. R = (1.8*k) +   0

   NB.  Do all conversions at once (eval
   NB.  polynomials in parallel). This is the
   NB.  numeric matrix J programs would manipulate
   NB.  directly.
   k2KCFR =:  (K2K , K2C , K2F ,: K2R) p./ ]
