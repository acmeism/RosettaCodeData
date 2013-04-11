(de matMul (Mat1 Mat2)
   (mapcar
      '((Row)
         (apply mapcar Mat2
            '(@ (sum * Row (rest))) ) )
      Mat1 ) )

(matMul
   '((1 2 3) (4 5 6))
   '((6 -1) (3 2) (0 -3)) )
