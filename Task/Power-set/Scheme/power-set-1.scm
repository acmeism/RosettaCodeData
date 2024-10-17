(define (power-set set)
  (if (null? set)
      '(())
      (let ((rest (power-set (cdr set))))
        (append (map (lambda (element) (cons (car set) element))
                     rest)
                rest))))

(display (power-set (list 1 2 3)))
(newline)

(display (power-set (list "A" "C" "E")))
(newline)
