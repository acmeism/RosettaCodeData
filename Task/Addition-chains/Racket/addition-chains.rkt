#lang rosette

(define (basic-constraints xs n)
  (assert (= 1 (first xs)))
  (assert (= n (last xs)))
  (assert (apply < xs))
  (for ([x (in-list (rest xs))] [xi (in-naturals 1)])
    (assert
     (apply || (for*/list ([(y yi) (in-parallel (in-list xs) (in-range xi))]
                           [(z zi) (in-parallel (in-list xs) (in-range xi))])
                 (= x (+ y z)))))))

(define (next-sol xs the-mod)
  (not (apply && (for/list ([x (in-list xs)]) (= x (evaluate x the-mod))))))

(define (try-len r n enumerate?)
  (define xs (build-list (add1 r)
                         (thunk* (define-symbolic* x integer?)
                                 x)))
  (basic-constraints xs n)
  (define sols (let loop ([sols '()])
                 (define the-mod (solve #t))
                 (cond
                   [(unsat? the-mod) sols]
                   [enumerate? (assert (next-sol xs the-mod))
                               (loop (cons (evaluate xs the-mod) sols))]
                   [else (list (evaluate xs the-mod))])))
  (clear-state!)
  (if (empty? sols) #f (cons sols r)))

(define (brauer? xs)
  (for/and ([x (in-list (rest xs))] [xi (in-naturals 1)] [x* (in-list xs)])
    (for/or ([y (in-list xs)] [yi (in-range xi)]) (= x (+ x* y)))))

(define (report-chain chain name)
  (printf "#~a chains: ~a\n" name (length chain))
  (when (not (empty? chain)) (printf "example: ~a\n" (first chain))))

(define (compute n enumerate?)
  (define sols (for/or ([r (in-naturals 1)]) (try-len r n enumerate?)))
  (printf "minimal chain length l(~a) = ~a\n" n (cdr sols))
  (cond
    [enumerate?
     (define-values (brauer-chain non-brauer-chain) (partition brauer? (car sols)))
     (report-chain brauer-chain "brauer")
     (report-chain non-brauer-chain "non-brauer")]
    [else (printf "example: ~a\n" (first (car sols)))]))

(define (compute/time n #:enumerate? enumerate?)
  (match-define-values (_ _ real _) (time-apply compute (list n enumerate?)))
  (printf "total time (ms): ~a\n\n" real))

(for ([x (in-list '(19 7 14 21 29 32 42 64 47 79))])
  (compute/time x #:enumerate? #t))

(for ([x (in-list '(191 382 379 12509))])
  (compute/time x #:enumerate? #f))
