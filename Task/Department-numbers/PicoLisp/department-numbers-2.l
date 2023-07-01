(be departments (@Pol @Fire @San)
   (member @Pol (2 4 6))
   (for @Fire 1 7)
   (for @San 1 7)
   (different @Pol @Fire)
   (different @Pol @San)
   (different @Fire @San)
   (^ @
      (= 12
         (+ (-> @Pol) (-> @Fire) (-> @San)) ) ) )
