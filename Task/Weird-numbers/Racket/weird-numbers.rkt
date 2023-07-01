#lang racket

(require math/number-theory)

(define (abundant? n proper-divisors)
  (> (apply + proper-divisors) n))

(define (semi-perfect? n proper-divisors)
    (let recur ((ds proper-divisors) (n n))
      (or (zero? n)
          (and (positive? n)
               (pair? ds)
               (or (recur (cdr ds) n)
                   (recur (cdr ds) (- n (car ds))))))))

(define (weird? n)
  (let ((proper-divisors (drop-right (divisors n) 1))) ;; divisors includes n
    (and (abundant? n proper-divisors) (not (semi-perfect? n proper-divisors)))))

(module+ main
  (let recur ((i 0) (n 1) (acc null))
    (cond [(= i 25) (reverse acc)]
          [(weird? n) (recur (add1 i) (add1 n) (cons n acc))]
          [else (recur i (add1 n) acc)])))

(module+ test
  (require rackunit)
  (check-true (weird? 70))
  (check-false (weird? 12)))
