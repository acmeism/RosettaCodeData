(define (even-or-odd? i)
  (letrec ([even? (λ (n)
                    (if (= n 0)
                        'even
                        (odd? (sub1 n))))]
           [odd? (λ (n)
                   (if (= n 0)
                       'odd
                       (even? (sub1 n))))])
    (even? i)))

(even-or-odd? 100)  ; => 'even
(even-or-odd? 101)  ; => 'odd
