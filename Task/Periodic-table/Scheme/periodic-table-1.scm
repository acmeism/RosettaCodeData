(define (position-increment n)
  (cond
   ((= n   1) '( 0 .  17))
   ((= n   2) '( 1 . -17))
   ((= n   4) '( 0 .  11))
   ((= n  10) '( 1 . -17))
   ((= n  12) '( 0 .  11))
   ((= n  18) '( 1 . -17))
   ((= n  36) '( 1 . -17))
   ((= n  54) '( 1 . -17))
   ((= n  56) '( 2 .   2))
   ((= n  71) '(-2 . -14))
   ((= n  86) '( 1 . -17))
   ((= n  88) '( 2 .   2))
   ((= n 103) '(-2 . -14))
   (else      '( 0 .   1))))

(define (move p i)
  (cons (+ (car p) (car i))
        (+ (cdr p) (cdr i))))

(define (position n)
  (if (= n 1)
      '(1 . 1)
      (let ((m (- n 1)))
        (move (position m)
              (position-increment m)))))

(define (format-line n p)
  (display n)
  (display " -> ")
  (display (car p))
  (display " ")
  (display (cdr p))
  (newline))

(for-each (lambda (n)
            (format-line n (position n)))
          (list 1 2 29 42 57 58 72 89))
