(import (scheme base)
        (scheme inexact)
        (scheme write)
        (only (srfi 1) fold))

;; return a list of the proper-divisors of n
(define (proper-divisors n)
  (let ((root (sqrt n)))
    (let loop ((divisors (list 1))
               (i 2))
      (if (> i root)
        divisors
        (loop (if (zero? (modulo n i))
                (if (= (square i) n)
                  (cons i divisors)
                  (append (list i (quotient n i)) divisors))
                divisors)
              (+ 1 i))))))

(define (sum-proper-divisors n)
  (if (< n 2)
    0
    (fold + 0 (proper-divisors n))))

(define *max-n* 20000)

;; hold sums of proper divisors in a cache, to avoid recalculating
(define *cache* (make-vector (+ 1 *max-n*)))
(for-each (lambda (i) (vector-set! *cache* i (sum-proper-divisors i)))
          (iota *max-n* 1))

(define (amicable-pair? i j)
  (and (not (= i j))
       (= i (vector-ref *cache* j))
       (= j (vector-ref *cache* i))))

;; double loop to *max-n*, displaying all amicable pairs
(let loop-i ((i 1))
  (when (<= i *max-n*)
    (let loop-j ((j i))
      (when (<= j *max-n*)
        (when (amicable-pair? i j)
          (display (string-append "Amicable pair: "
                                  (number->string i)
                                  " "
                                  (number->string j)))
          (newline))
        (loop-j (+ 1 j))))
    (loop-i (+ 1 i))))
