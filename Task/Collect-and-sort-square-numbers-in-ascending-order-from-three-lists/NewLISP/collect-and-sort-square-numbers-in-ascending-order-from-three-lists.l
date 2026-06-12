(define (sqr? n) (= n (pow (round (sqrt n)) 2)))

(sort (filter sqr? (flat
  '((3 4 34 25 9 12 36 56 36)
    (2 8 81 169 34 55 76 49 7)
    (75 121 75 144 35 16 46 35)))))
