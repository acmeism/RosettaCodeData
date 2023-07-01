#lang racket

(define fact
  (curry list-ref (for/fold ([result (list 1)] #:result (reverse result))
                            ([x (in-range 1 20)])
                    (cons (* x (first result)) result))))

(for ([b (in-range 9 13)])
  (printf "The factorions for base ~a are:\n" b)
  (for ([i (in-range 1 1500000)])
    (let loop ([sum 0] [n i])
      (cond
        [(positive? n) (loop (+ sum (fact (modulo n b))) (quotient n b))]
        [(= sum i) (printf "~a " i)])))
  (newline))
