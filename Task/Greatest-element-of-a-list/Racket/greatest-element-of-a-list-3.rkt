(define (my-max l)
  (define (max-h l greatest)
    (cond [(empty? l) greatest]
          [(> (first l) greatest) (max-h (rest l) (first l))]
          [else (max-h (rest l) greatest)]))
  (if (empty? l) empty (max-h l (first l))))
