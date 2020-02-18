(load "@lib/simul.l")
(de magic (A)
   (let
      (Grid (grid A A T T)
         Sum (/ (* A (inc (** A 2))) 2))
      (println 'N A 'Sum Sum)
      # cut one important edge
      (with (last (last Grid)) (con (: 0 1)))
      (with (get Grid (inc (/ A 2)) A)
         (for N (* A A)
            (=: V N)
            (setq This
               (if
                  (with (setq @@ (north (east This)))
                     (not (: V)) )
                  @@
                  (south This) ) ) ) )
      # display
      (mapc
         '((L)
            (for This L
               (prin (align 4 (: V))) )
            (prinl) )
         Grid )
      # clean
      (mapc '((L) (mapc zap L)) Grid) ) )
(magic 5)
(prinl)
(magic 7)
