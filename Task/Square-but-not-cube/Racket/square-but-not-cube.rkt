#lang racket
(require racket/generator)

;; generates values:
;;  next square
;;  cube-root if cube, #f otherwise
(define (make-^2-but-not-^3-generator)
  (generator
   ()
   (let loop ((s 1) (c 1))
     (let ((s^2 (sqr s)) (c^3 (* c c c)))
       (yield s^2 (and (= s^2 c^3) c))
       (loop (add1 s) (+ c (if (>= s^2 c^3) 1 0)))))))

(for/list ((x (in-range 1 31))
           ((s^2 _) (sequence-filter (λ (_ c) (not c)) (in-producer (make-^2-but-not-^3-generator)))))
  s^2)

(for ((x (in-range 1 4))
      ((s^2 c) (sequence-filter (λ (s^2 c) c) (in-producer (make-^2-but-not-^3-generator)))))
  (printf "~a: ~a is also ~a^3~%" x s^2 c))
