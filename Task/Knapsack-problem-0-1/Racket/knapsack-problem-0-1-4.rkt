(define (show-brute)

  (define empty-accumulator '())

  (define (knapsack-brute included items)
    (cond
      ((null? items) included)
      (else
       (max-pack-value
        (knapsack-brute (cons (car items) included) (cdr items))
        (knapsack-brute included (cdr items))
        max-weight
        ))))

  (display-solution (reverse (knapsack-brute empty-accumulator items))))

(show-brute); takes around five seconds on my machine
