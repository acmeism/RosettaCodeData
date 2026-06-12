(define (rotate lst n)
  (if (> n 0)
    (append (drop lst n) (take lst n))
    (append (take-right lst (abs n)) (drop-right lst (abs n)))))

(rotate '(0 1 2 3 4 5 6 7) 3)

(3 4 5 6 7 0 1 2)

(rotate '(0 1 2 3 4 5 6 7) -3)

(5 6 7 0 1 2 3 4)
