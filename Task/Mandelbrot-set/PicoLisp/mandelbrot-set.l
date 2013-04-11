(scl 6)

(let Ppm (make (do 300 (link (need 400))))
   (for (Y . Row) Ppm
      (for (X . @) Row
         (let (ZX 0  ZY 0  CX (*/ (- X 250) 1.0 150)  CY (*/ (- Y 150) 1.0 150)  C 570)
            (while (and (> 4.0 (+ (*/ ZX ZX 1.0) (*/ ZY ZY 1.0))) (gt0 C))
               (let Tmp (- (*/ ZX ZX 1.0) (*/ ZY ZY 1.0) (- CX))
                  (setq
                     ZY (+ (*/ 2 ZX ZY 1.0) CY)
                     ZX Tmp ) )
               (dec 'C) )
            (set (nth Ppm Y X) (list 0 C C)) ) ) )
   (out "img.ppm"
      (prinl "P6")
      (prinl 400 " " 300)
      (prinl 255)
      (for Y Ppm (for X Y (apply wr X))) ) )
