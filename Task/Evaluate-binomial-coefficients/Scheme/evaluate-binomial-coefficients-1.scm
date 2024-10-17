(define (factorial n)
  (define (*factorial n acc)
    (if (zero? n)
        acc
        (*factorial (- n 1) (* acc n))))
  (*factorial n 1))

(define (choose n k)
  (/ (factorial n) (* (factorial k) (factorial (- n k)))))

(display (choose 5 3))
(newline)
