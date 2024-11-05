(define (f m n)
  (define (sigma g x y)
    (define (sum i)
      (if (< i 0) 0 (+ (f x (- y i) ) (sum (- i 1)))))
    (sum y))
  (cond ((eq? m n) 1)
        ((eq? n 1) 1)
        ((eq? n 0) 0)
        ((< m n) (f m m))
        ((< (/ m 2) n) (sigma f (- m n) (- m n)))
        (else (sigma f (- m n) n))))
(define (line m)
  (define (connect i)
    (if (> i m) '() (cons (f m i) (connect (+ i 1)))))
  (connect 1))
(define (print x)
  (define (print-loop i)
    (cond ((< i x) (begin (display (line i)) (display "\n") (print-loop (+ i 1)) ))))
  (print-loop 1))
(print 25)