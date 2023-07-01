(scl 2)
(let
   (Before
      (+
         (* 4000000000000000 5.50)
         (* 2 2.86) )
      Tax (*/ Before 7.65 100.00)
      Total (+ Before Tax)
      Fmt (17 27) )
   (tab Fmt "Total before tax:" (format Before *Scl "." ","))
   (tab Fmt "Tax:" (format Tax *Scl "." ","))
   (tab Fmt "Total:" (format Total *Scl "." ",")) )
