(import (rnrs))

(define (calc-pi yield)
  (let loop ((q 1) (r 0) (t 1) (k 1) (n 3) (l 3))
    (if (< (- (+ (* 4 q) r) t) (* n t))
        (begin
          (yield n)
          (loop (* q  10)
                (* 10 (- r (* n t)))
                t
                k
                (- (div (* 10 (+ (* 3 q) r)) t) (* 10 n))
                l))
        (begin
          (loop (* q k)
                (* (+ (* 2 q) r) l)
                (* t l)
                (+ k 1)
                (div (+ (* q (* 7 k)) 2 (* r l)) (* t l))
                (+ l 2))))))

(let ((i 0))
  (calc-pi
    (lambda (d)
      (display d)
      (set! i (+ i 1))
      (if (= 40 i)
          (begin
            (newline)
            (set! i 0))))))
