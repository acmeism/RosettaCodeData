(import (rnrs))

(define (e)
  (sum
    (map
      (lambda (x) (/ 1.0 x))
      (scanl
        (lambda (a x) (* a x))
        1
        (enum-from-to 1 20)))))

(define (enum-from-to m n)
  (if (>= n m)
      (iterate-until (lambda (x) (>= x n)) (lambda (x) (+ 1 x)) m)
      '()))

(define (iterate-until p f x)
  (let loop ((vs (list x)) (h x))
      (if (p h)
          (reverse vs)
          (loop (cons (f h) vs) (f h)))))

(define (sum xs)
  (fold-left + 0 xs))

(define-record-type scan (fields acc scan))

(define (scanl f start-value xs)
  (scan-scan
    (fold-left
      (lambda (a x)
        (let ((v (f (scan-acc a) x)))
          (make-scan v (cons v (scan-scan a)))))
      (make-scan start-value (cons start-value '()))
      xs)))

(display (e))
(newline)
