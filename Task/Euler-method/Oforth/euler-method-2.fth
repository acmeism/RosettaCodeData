: newtonCoolingLaw(t, y)
   y 20 - -0.07 * ;

: test
   euler(#newtonCoolingLaw, 100.0, 0.0, 100.0,  2)
   euler(#newtonCoolingLaw, 100.0, 0.0, 100.0,  5)
   euler(#newtonCoolingLaw, 100.0, 0.0, 100.0, 10) ;
