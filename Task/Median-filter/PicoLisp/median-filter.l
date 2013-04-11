(de ppmMedianFilter (Radius Ppm)
   (let Len (inc (* 2 Radius))
      (make
         (chain (head Radius Ppm))
         (for (Y Ppm  T  (cdr Y))
            (NIL (nth Y Len)
               (chain (tail Radius Y)) )
            (link
               (make
                  (chain (head Radius (get Y (inc Radius))))
                  (for (X (head Len Y) T)
                     (NIL (nth X 1 Len)
                        (chain (tail Radius (get X (inc Radius)))) )
                     (link
                        (cdr
                           (get
                              (sort
                                 (mapcan
                                    '((Y)
                                       (mapcar
                                          '((C)
                                             (cons
                                                (+
                                                   (* (car C) 2126)     # Red
                                                   (* (cadr C) 7152)    # Green
                                                   (* (caddr C) 722) )  # Blue
                                                C ) )
                                          (head Len Y) ) )
                                    X ) )
                              (inc Radius) ) ) )
                     (map pop X) ) ) ) ) ) ) )
