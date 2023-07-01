#lang racket/base
(provide fold-divisors ; name as per "Abundant..."
         proper-divisors)

(define (fold-divisors v n k0 kons)
  (define n1 (add1 n))
  (cond
    [(>= n1 (vector-length v))
     (define rv (make-vector n1 k0))
     (for* ([n (in-range 1 n1)] [m (in-range (* 2 n) n1 n)])
       (vector-set! rv m (kons n (vector-ref rv m))))
     rv]
    [else v]))

(define proper-divisors
  (let ([p.d-v (vector)])
    (λ (n)
      (set! p.d-v (reverse (fold-divisors p.d-v n null cons)))
      (vector-ref p.d-v n))))

(module+ main
  (for ([n (in-range 1 (add1 10))])
    (printf "proper divisors of: ~a\t~a\n" n (proper-divisors n)))

  (define count-proper-divisors
    (let ([p.d-v (vector)])
      (λ(n) (set! p.d-v (fold-divisors p.d-v n 0 (λ (d n) (add1 n))))
            (vector-ref p.d-v n))))

  (void (count-proper-divisors 20000))

  (define-values [C I]
    (for*/fold ([C 0] [I 1])
               ([i (in-range 1 (add1 20000))]
                [c (in-value (count-proper-divisors i))]
                #:when [> c C])
      (values c i)))
  (printf "~a has ~a proper divisors\n" I C))
