(load "@lib/simul.l")

(scl 3)

(de forestFire (Dim ProbT ProbP ProbF)
   (let Grid (grid Dim Dim)
      (for Col Grid
         (for This Col
            (=: tree (> ProbT (rand 0 1.0))) ) )
      (loop
         (disp Grid NIL
            '((This)
               (cond
                  ((: burn) "# ")
                  ((: tree) "T ")
                  (T ". ") ) ) )
         (wait 1000)
         (for Col Grid
            (for This Col
               (=: next
                  (cond
                     ((: burn) NIL)
                     ((: tree)
                        (if
                           (or
                              (find  # Neighbor burning?
                                 '((Dir) (get (Dir This) 'burn))
                                 (quote
                                    west east south north
                                    ((X) (south (west X)))
                                    ((X) (north (west X)))
                                    ((X) (south (east X)))
                                    ((X) (north (east X))) ) )
                              (> ProbF (rand 0 1.0)) )
                           'burn
                           'tree ) )
                     (T (and (> ProbP (rand 0 1.0)) 'tree)) ) ) ) )
         (for Col Grid
            (for This Col
               (if (: next)
                  (put This @ T)
                  (=: burn)
                  (=: tree) ) ) ) ) ) )
