(define (a-mean l)
  (/ (apply + l) (length l)))

(define (g-mean l)
  (expt (apply * l) (/ (length l))))

(define (h-mean l)
  (/ (length l) (apply + (map / l))))

(define (iota start stop)
  (if (> start stop)
      (list)
      (cons start (iota (+ start 1) stop))))

(let* ((l (iota 1 10)) (a (a-mean l)) (g (g-mean l)) (h (h-mean l)))
  (display a)
  (display " >= ")
  (display g)
  (display " >= ")
  (display h)
  (newline)
  (display (>= a g h))
  (newline))
