(de floyd (N)
   (let
      (Rows
         (make
            (for ((I . L) (range 1 (/ (* N (inc N)) 2))  L)
               (link (cut I 'L)) ) )
         Fmt (mapcar length (last Rows)) )
      (map inc (cdr Fmt))
      (for R Rows
         (apply tab R Fmt) ) ) )
