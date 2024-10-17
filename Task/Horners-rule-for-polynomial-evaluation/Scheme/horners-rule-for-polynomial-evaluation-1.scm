(define (horner lst x)
  (define (*horner lst x acc)
    (if (null? lst)
        acc
        (*horner (cdr lst) x (+ (* acc x) (car lst)))))
  (*horner (reverse lst) x 0))

(display (horner (list -19 7 -4 6) 3))
(newline)
