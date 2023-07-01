#lang racket

(require math/number-theory)

(define (Legendre a p)
  (modexpt a (quotient (sub1 p) 2)))

(define (Tonelli n p (err (λ (n p) (error "not a square (mod p)" (list n p)))))
  (with-modulus p
    (unless (= 1 (Legendre n p)) (err n p))

    (define-values (q s)
      (let even?-q-loop ((q (sub1 p)) (s 0))
        (if (even? q)
            (even?-q-loop (quotient q 2) (add1 s))
            (values q s))))

    (cond
      [(= s 1)
       (modexpt n (/ (add1 p) 4))]
      [else
       (define z (for/first ((z (in-range 2 p)) #:when (= (sub1 p) (Legendre z p))) z))
       (let loop ((c (modexpt z q))
                  (r (modexpt n (quotient (add1 q) 2)))
                  (t (modexpt n q))
                  (m s))
         (cond
           [(mod= 1 t)
            r]
           [else
            (define-values (t2 m′) (for/fold ((t2 (modsqr t)) (i 1))
                                             ((j (in-range 1 m)) #:final (mod= t2 1))
                                     (values (modsqr t2) j)))
            (define b (modexpt c (expt 2 (- m m′ 1))))
            (define c′ (modsqr b))
            (loop c′ (mod* r b) (mod* t c′) m′)]))])))

(module+ test
  (require rackunit)

  (define ttest
    `((10 13)
      (56 101)
      (1030 10009)
      (44402 100049)
      (665820697 1000000009)
      (881398088036  1000000000039)
      (41660815127637347468140745042827704103445750172002
       ,(+ #e1e50 577))))

  (define (task ttest)
    (for ((test ttest))
      (define n (first test))
      (define p (second test))
      (define r (Tonelli n p))
      (printf "n = ~a p = ~a~%  roots : ~a ~a~%" n p r (- p r))))

  (task ttest)

  (check-exn exn:fail? (λ () (Tonelli 1032 1009))))
