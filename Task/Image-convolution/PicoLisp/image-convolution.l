(scl 3)

(de ppmConvolution (Ppm Kernel)
   (let (Len (length (car Kernel))  Radius (/ Len 2))
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
                        (make
                           (for C 3
                              (let Val 0
                                 (for K Len
                                    (for L Len
                                       (inc 'Val
                                          (* (get X K L C) (get Kernel K L)) ) ) )
                                 (link (min 255 (max 0 (*/ Val 1.0)))) ) ) ) )
                     (map pop X) ) ) ) ) ) ) )
