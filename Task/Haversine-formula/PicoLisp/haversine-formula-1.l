(scl 12)
(load "@lib/math.l")

(de haversine (Th1 Ph1 Th2 Ph2)
   (setq
      Ph1 (*/ (- Ph1 Ph2) pi 180.0)
      Th1 (*/ Th1 pi 180.0)
      Th2 (*/ Th2 pi 180.0) )
   (let
      (DX (- (*/ (cos Ph1) (cos Th1) 1.0) (cos Th2))
         DY (*/ (sin Ph1) (cos Th1) 1.0)
         DZ (- (sin Th1) (sin Th2)) )
      (* `(* 2 6371)
         (asin
            (/
               (sqrt (+ (* DX DX) (* DY DY) (* DZ DZ)))
               2 ) ) ) ) )
