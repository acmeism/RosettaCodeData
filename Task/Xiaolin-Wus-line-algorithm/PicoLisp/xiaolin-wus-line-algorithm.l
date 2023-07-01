(scl 2)

(de plot (Img X Y C)
   (set (nth Img (*/ Y 1.0) (*/ X 1.0)) (- 100 C)) )

(de ipart (X)
   (* 1.0 (/ X 1.0)) )

(de iround (X)
   (ipart (+ X 0.5)) )

(de fpart (X)
   (% X 1.0) )

(de rfpart (X)
   (- 1.0 (fpart X)) )

(de xiaolin (Img X1 Y1 X2 Y2)
   (let (DX (- X2 X1)  DY (- Y2 Y1))
      (use (Grad Xend Yend Xgap Xpxl1 Ypxl1 Xpxl2 Ypxl2 Intery)
         (when (> (abs DY) (abs DX))
            (xchg 'X1 'Y1  'X2 'Y2) )
         (when (> X1 X2)
            (xchg 'X1 'X2  'Y1 'Y2) )
         (setq
            Grad (*/ DY 1.0 DX)
            Xend (iround X1)
            Yend (+ Y1 (*/ Grad (- Xend X1) 1.0))
            Xgap (rfpart (+ X1 0.5))
            Xpxl1 Xend
            Ypxl1 (ipart Yend) )
         (plot Img Xpxl1 Ypxl1 (*/ (rfpart Yend) Xgap 1.0))
         (plot Img Xpxl1 (+ 1.0 Ypxl1) (*/ (fpart Yend) Xgap 1.0))
         (setq
            Intery (+ Yend Grad)
            Xend (iround X2)
            Yend (+ Y2 (*/ Grad (- Xend X2) 1.0))
            Xgap (fpart (+ X2 0.5))
            Xpxl2 Xend
            Ypxl2 (ipart Yend) )
         (plot Img Xpxl2 Ypxl2 (*/ (rfpart Yend) Xgap 1.0))
         (plot Img Xpxl2 (+ 1.0 Ypxl2) (*/ (fpart Yend) Xgap 1.0))
         (for (X (+ Xpxl1 1.0)  (>= (- Xpxl2 1.0) X)  (+ X 1.0))
            (plot Img X (ipart Intery) (rfpart Intery))
            (plot Img X (+ 1.0 (ipart Intery)) (fpart Intery))
            (inc 'Intery Grad) ) ) ) )

(let Img (make (do 90 (link (need 120 99))))       # Create image 120 x 90
   (xiaolin Img 10.0 10.0 110.0 80.0)              # Draw lines
   (xiaolin Img 10.0 10.0 110.0 45.0)
   (xiaolin Img 10.0 80.0 110.0 45.0)
   (xiaolin Img 10.0 80.0 110.0 10.0)
   (out "img.pgm"                                  # Write to bitmap file
      (prinl "P2")
      (prinl 120 " " 90)
      (prinl 100)
      (for Y Img (apply printsp Y)) ) )
