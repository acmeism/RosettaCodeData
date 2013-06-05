#lang racket
(require math)

(define (order a n)
  (unless (coprime? a n) (error 'order "arguments must be coprime"))
  (for/fold ([o 1]) ([r (factorize n)])
    (lcm o (order1 a r))))

(define (order1 a p&e)
  (match-define (list p e) p&e)
  (define m (expt p e))
  (define t (* (- p 1) (expt p (- e 1))))
  (define qs
    (for/fold ([qs '(1)]) ([f (factorize t)])
       (match f [(list f0 f1)
                 (for*/list ([q qs] [j (in-range (+ 1 f1))])
                   (* q (expt f0 j)))])))
  (for/or ([q (sort qs <)] #:when (= (modular-expt a q m) 1)) q))


(order 37 1000)
(order (+ (expt 10 100) 1) 7919)
(order (+ (expt 10 1000) 1) 15485863)
(order (- (expt 10 10000) 1) 22801763489)
(order 13 (+ 1 (expt 10 80)))
