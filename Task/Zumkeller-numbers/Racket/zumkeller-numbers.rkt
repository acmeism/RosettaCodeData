#lang racket

(require math/number-theory)

(define (zum? n)
  (let* ((set (divisors n))
         (sum (apply + set)))
    (cond
      [(odd? sum) #f]
      [(odd? n) ; if n is odd use 'abundant odd number' optimization
       (let ((abundance (- sum (* n 2)))) (and (positive? abundance) (even? abundance)))]
      [else
       (let ((sum/2 (quotient sum 2)))
         (let loop ((acc (car set)) (set (cdr set)))
           (cond [(= acc sum/2) #t]
                 [(> acc sum/2) #f]
                 [(null? set) #f]
                 [else (or (loop (+ (car set) acc) (cdr set))
                           (loop acc (cdr set)))])))])))

(define (first-n-matching-naturals count pred)
  (for/list ((i count) (j (stream-filter pred (in-naturals 1)))) j))

(define (tabulate title ns (row-width 132))
  (displayln title)
  (let* ((cell-width (+ 2 (order-of-magnitude (apply max ns))))
         (cells/row (quotient row-width cell-width)))
    (let loop ((ns ns) (col cells/row))
      (cond [(null? ns) (unless (= col cells/row) (newline))]
            [(zero? col) (newline) (loop ns cells/row)]
            [else (display (~a #:width cell-width #:align 'right (car ns)))
                  (loop (cdr ns) (sub1 col))]))))


(tabulate  "First 220 Zumkeller numbers:" (first-n-matching-naturals 220 zum?))
(newline)
(tabulate "First 40 odd Zumkeller numbers:"
          (first-n-matching-naturals 40 (λ (n) (and (odd? n) (zum? n)))))
(newline)
(tabulate "First 40 odd Zumkeller numbers not ending in 5:"
          (first-n-matching-naturals 40 (λ (n) (and (odd? n) (not (= 5 (modulo n 10))) (zum? n)))))
