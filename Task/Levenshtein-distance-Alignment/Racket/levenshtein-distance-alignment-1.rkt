#lang racket

(define (memoize f)
  (local ([define table (make-hash)])
    (lambda args
      (dict-ref! table args (λ () (apply f args))))))

(define levenshtein
  (memoize
   (lambda (s t)
     (cond
       [(and (empty? s) (empty? t)) 0]
       [(empty? s) (length t)]
       [(empty? t) (length s)]
       [else
        (if (equal? (first s) (first t))
            (levenshtein (rest s) (rest t))
            (min (add1 (levenshtein (rest s) t))
                 (add1 (levenshtein s (rest t)))
                 (add1 (levenshtein (rest s) (rest t)))))]))))
