#lang racket
(require racket/generator)

(define pidig
  (generator ()
    (let loop ([q 1] [r 0] [t 1] [k 1] [n 3] [l 3])
      (if (< (- (+ r (* 4 q)) t) (* n t))
        (begin (yield n)
               (loop (* q 10) (* 10 (- r (* n t))) t k
                     (- (quotient (* 10 (+ (* 3 q) r)) t) (* 10 n))
                     l))
        (loop (* q k) (* (+ (* 2 q) r) l) (* t l) (+ 1 k)
              (quotient (+ (* (+ 2 (* 7 k)) q) (* r l)) (* t l))
              (+ l 2))))))

(for ([i (in-naturals)])
  (display (pidig))
  (when (zero? i) (display "." ))
  (when (zero? (modulo i 80)) (newline)))
