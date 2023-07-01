(let Img (make (do 200 (link (need 300 0))))       # Create image 300 x 200
   (quadBezier Img 12 20 100 300 -80 260 180)
   (out "img.pbm"                                  # Write to bitmap file
      (prinl "P1")
      (prinl 300 " " 200)
      (mapc prinl Img) ) )

(call 'display "img.pbm")
