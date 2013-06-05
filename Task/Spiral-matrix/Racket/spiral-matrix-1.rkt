#lang racket
(require math)

(define (spiral rows columns)
  (define (index x y) (+ (* x columns) y))
  (do ((N (* rows columns))
       (spiral (make-vector (* rows columns) #f))
       (dx 1) (dy 0) (x 0) (y 0)
       (i 0 (+ i 1)))
      ((= i N) spiral)
    (vector-set! spiral (index y x) i)
    (let ((nx (+ x dx)) (ny (+ y dy)))
      (cond
       ((and (< -1 nx columns)
             (< -1 ny rows)
             (not (vector-ref spiral (index ny nx))))
        (set! x nx)
        (set! y ny))
       (else
        (set!-values (dx dy) (values (- dy) dx))
        (set! x (+ x dx))
        (set! y (+ y dy)))))))

(vector->matrix 4 4 (spiral 4 4))
