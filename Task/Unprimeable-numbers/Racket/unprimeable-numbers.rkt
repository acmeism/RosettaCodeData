#lang racket

(require math/number-theory)

(define cached-prime?
  (let ((hsh# (make-hash))) (λ (p) (hash-ref! hsh# p (λ () (prime? p))))))

(define (zero-digit n d)
  (define p (expt 10 d))
  (+ (remainder n p) (* 10 p (quotient n (* p 10)))))

(define (primeable? n)
  (or (cached-prime? n)
      (for*/first ((d (in-range (add1 (order-of-magnitude n))))
                   (n0 (in-value (zero-digit n d)))
                   (p (in-value (expt 10 d)))
                   (r (in-range 10))
                   (n+ (in-value (+ n0 (* r p))))
                   #:when (cached-prime? n+))
                  n+)))

(define unprimeable? (negate primeable?))

(module+
  main
  (printf "First 35 unprimeable numbers: ~a~%"
          (let recur ((i 0) (n 1) (acc null))
            (cond [(= i 35) (reverse acc)]
                  [(unprimeable? n) (recur (add1 i) (add1 n) (cons n acc))]
                  [else (recur i (add1 n) acc)])))

  (printf "600th unprimeable number: ~a~%"
             (let recur ((i 0) (n 1) (u #f))
               (cond [(= i 600) u]
                     [(unprimeable? n) (recur (add1 i) (add1 n) n)]
                     [else (recur i (add1 n) u)])))

  (for ((d 10))
       (printf "Least unprimeable number ending in ~a = ~a~%" d
               (for/first ((i (in-range (+ 100 d) +Inf.0 10)) #:when (unprimeable? i)) i))))

(module+ test
  (require rackunit)
  (check-equal? (zero-digit 1234 2) 1034)
  (check-equal? (primeable? 10) 11)
  (check-true (unprimeable? 200))
  (check-false (unprimeable? 201)))
