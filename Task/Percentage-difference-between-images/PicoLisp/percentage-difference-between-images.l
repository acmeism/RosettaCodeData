(call "convert" "Lenna50.jpg" (tmp "Lenna50.ppm"))
(call "convert" "Lenna100.jpg" (tmp "Lenna100.ppm"))

(let (Total 0  Diff 0)
   (in (tmp "Lenna50.ppm")
      (in (tmp "Lenna100.ppm")
         (while (rd 1)
            (inc 'Diff
               (*/
                  (abs (- @ (in -1 (rd 1))))
                  1000000
                  255 ) )
            (inc 'Total) ) ) )
   (prinl "Difference is " (format (*/ Diff Total) 4) " percent") )
