(define sylvester
  (lambda (x)
    (if (= x 1)
      2
      (let ((n (sylvester (- x 1)))) (- (* n n) n -1)))))
(define list (map sylvester '(1 2 3 4 5 6 7 8 9 10)))
(print list)
(newline)
(print (apply + (map / list)))
