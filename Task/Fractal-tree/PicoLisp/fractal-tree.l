(load "@lib/math.l")

(de fractalTree (Img X Y A D)
   (unless (=0 D)
      (let (R (*/ A pi 180.0)  DX (*/ (cos R) D 0.2)  DY (*/ (sin R) D 0.2))
         (brez Img X Y DX DY)
         (fractalTree Img (+ X DX) (+ Y DY) (+ A 30.0) (dec D))
         (fractalTree Img (+ X DX) (+ Y DY) (- A 30.0) (dec D)) ) ) )

(let Img (make (do 300 (link (need 400 0))))       # Create image 400 x 300
   (fractalTree Img 200 300 -90.0 10)              # Draw tree
   (out "img.pbm"                                  # Write to bitmap file
      (prinl "P1")
      (prinl 400 " " 300)
      (mapc prinl Img) ) )
