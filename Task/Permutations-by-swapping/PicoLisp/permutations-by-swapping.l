(let
   (N 4
      L
      (mapcar
         '((I) (list I 0))
         (range 1 N) ) )
   (for I L
      (printsp (car I)) )
   (prinl)
   (while
      # find the lagest mobile integer
      (setq
         X
         (maxi
            '((I) (car (get L (car I))))
            (extract
               '((I J)
                  (let? Y
                     (get
                        L
                        ((if (=0 (cadr I)) dec inc) J) )
                     (when (> (car I) (car Y))
                        (list J (cadr I)) ) ) )
               L
               (range 1 N) ) )
         Y (get L (car X)) )
      # swap integer and adjacent int it is looking at
      (xchg
         (nth L (car X))
         (nth
            L
            ((if (=0 (cadr X)) dec inc) (car X)) ) )
      # reverse direction of all ints large than our
      (for I L
         (when (< (car Y) (car I))
            (set (cdr I)
               (if (=0 (cadr I)) 1 0) ) ) )
      # print current positions
      (for I L
         (printsp (car I)) )
      (prinl) ) )
(bye)
