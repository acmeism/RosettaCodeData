(de cuboid (DX DY DZ)
   (cubLine (inc DY) "+" DX "-" 0)
   (for I DY
      (cubLine (- DY I -1) "/" DX " " (dec I) "|") )
   (cubLine 0 "+" DX "-" DY "|")
   (do (- (* 4 DZ) DY 2)
      (cubLine 0 "|" DX " " DY "|") )
   (cubLine 0 "|" DX " " DY "+")
   (for I DY
      (cubLine 0 "|" DX " " (- DY I) "/") )
   (cubLine 0 "+" DX "-" 0) )

(de cubLine (N C DX D DY E)
   (space N)
   (prin C)
   (do (dec (* 9 DX)) (prin D))
   (prin C)
   (space DY)
   (prinl E) )
