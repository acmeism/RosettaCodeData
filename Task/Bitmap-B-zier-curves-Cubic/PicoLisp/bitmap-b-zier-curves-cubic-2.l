(let Img (make (do 200 (link (need 300 0))))       # Create image 300 x 200
   (cubicBezier Img 24 20 120 540 33 -225 33 285 100)
   (out "img.pbm"                                  # Write to bitmap file
      (prinl "P1")
      (prinl 300 " " 200)
      (mapc prinl Img) ) )

(call 'display "img.pbm")
