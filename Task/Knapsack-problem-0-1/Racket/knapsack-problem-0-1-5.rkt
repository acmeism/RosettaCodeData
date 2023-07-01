(define (show-memoized)

  (define (memoize func)
    (let ([result-ht (make-hash)])
      (lambda args ; this is the rest-id pattern
        (when (not (hash-has-key? result-ht args))
          (hash-set! result-ht args (apply func args)))
        (hash-ref result-ht args))))

  (define knapsack
    (memoize
     (lambda (max-weight items)
       (cond
         ((null? items) '())
         (else
          (let ([item (car items)] [items (cdr items)])
            (max-pack-value
             (cons item (knapsack (- max-weight (item-weight item)) items))
             (knapsack max-weight items)
             max-weight)))))))

  (display-solution (knapsack max-weight items)))

(show-memoized)
