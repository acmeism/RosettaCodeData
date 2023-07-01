(de closestPairBF (Lst)
   (let Min T
      (use (Pt1 Pt2)
         (for P Lst
            (for Q Lst
               (or
                  (== P Q)
                  (>=
                     (setq N
                        (let (A (- (car P) (car Q))  B (- (cdr P) (cdr Q)))
                           (+ (* A A) (* B B)) ) )
                     Min )
                  (setq Min N  Pt1 P  Pt2 Q) ) ) )
         (list Pt1 Pt2 (sqrt Min)) ) ) )
