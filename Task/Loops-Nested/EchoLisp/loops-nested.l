(lib 'math) ;; for 2D-arrays
(define array (build-array 42 42 (lambda(i j) (1+ (random 20)))))
 → array

;;
(for* ((row array) (aij row)) (write aij) #:break (= aij 20))
  → 9 8 11 1 14 11 1 9 16 1 10 5 5 6 5 4 13 17 14 13 6 10 16 4 8 5 1 17 16 19 4 6 18 1 15 3 4 13 19
  6 12 5 5 17 19 16 3 7 2 15 16 14 16 16 19 18 14 16 6 18 14 17 20
