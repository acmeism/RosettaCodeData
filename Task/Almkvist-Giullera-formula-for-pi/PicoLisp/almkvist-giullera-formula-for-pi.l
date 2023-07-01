(scl 70)
(de fact (N)
   (if (=0 N)
      1
      (* N (fact (dec N))) ) )
(de almkvist (N)
   (let
      (A (* 32 (fact (* 6 N)))
         B (+ (* 532 N N) (* 126 N) 9)
         C (* (** (fact N) 6) 3) )
      (/ (* A B) C) ) )
(de integral (N)
   (*/
      1.0
      (almkvist N)
      (** 10 (+ 3 (* 6 N))) ) )
(let (S 0  N -1)
   (do 10
      (println (inc 'N) (almkvist N)) )
   (prinl)
   (setq N -1)
   (while (gt0 (integral (inc 'N)))
      (inc 'S @) )
   (setq S (sqrt (*/ 1.0 1.0 S) 1.0))
   (prinl "Pi to 70 decimal places is:")
   (prinl (format S *Scl)) )
