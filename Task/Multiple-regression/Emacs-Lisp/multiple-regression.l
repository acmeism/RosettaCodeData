(let ((x1 '(0 1 2 3 4 5 6 7 8 9 10))
      (x2 '(0 1 1 3 3 7 6 7 3 9 8))
      (y '(1 6 17 34 57 86 121 162 209 262 321)))
  (apply #'calc-eval "fit(a*X1+b*X2+c,[X1,X2],[a,b,c],[$1 $2 $3])" nil
         (mapcar (lambda (items) (cons 'vec items)) (list x1 x2 y))))
