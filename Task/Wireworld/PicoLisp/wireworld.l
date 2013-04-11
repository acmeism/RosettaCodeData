(load "@lib/simul.l")

(let
   (Data (in "wire.data" (make (while (line) (link @))))
      Grid (grid (length (car Data)) (length Data)) )
   (mapc
      '((G D) (mapc put G '(val .) D))
      Grid
      (apply mapcar (flip Data) list) )
   (loop
      (disp Grid T
         '((This) (pack " " (: val) " ")) )
      (wait 1000)
      (for Col Grid
         (for This Col
            (case (=: next (: val))
               ("H" (=: next "t"))
               ("t" (=: next "."))
               ("."
                  (when
                     (>=
                        2
                        (cnt # Count neighbors
                           '((Dir) (= "H" (get (Dir This) 'val)))
                           (quote
                              west east south north
                              ((X) (south (west X)))
                              ((X) (north (west X)))
                              ((X) (south (east X)))
                              ((X) (north (east X))) ) )
                        1 )
                     (=: next "H") ) ) ) ) )
      (for Col Grid  # Update
         (for This Col
            (=: val (: next)) ) )
      (prinl) ) )
