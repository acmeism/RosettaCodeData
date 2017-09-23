   multiplier=. train@:((;:'&*') ;~ an@: *)

   ]A=. 2  ; 4  ; (2 + 4)   NB. Corresponds to  ]A=. box (1&o.)`(2&o.)`(^&3)
┌─┬─┬─┐
│2│4│6│
└─┴─┴─┘
   ]B=. %&.> A              NB. Corresponds to  ]B =. inverse&.> A
┌───┬────┬────────┐
│0.5│0.25│0.166667│
└───┴────┴────────┘
   ]BA=. B multiplier&.> A  NB. Corresponds to  B compose&.> A
┌───┬───┬───┐
│1&*│1&*│1&*│
└───┴───┴───┘
   BA of &> 0.5             NB. Corresponds to  BA of &> 0.5  (exactly)
0.5 0.5 0.5
