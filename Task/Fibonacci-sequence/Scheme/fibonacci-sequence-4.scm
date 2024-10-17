(define (fib)
  (define (nxt lv nv) (cons nv (lambda () (nxt nv (+ lv nv)))))
  (cons 0 (lambda () (nxt 0 1))))

;;; test...
(define (show-stream-take n strm)
  (define (shw-nxt n strm) (begin (display (car strm))
                                  (if (> n 1) (begin (display " ") (shw-nxt (- n 1) ((cdr strm)))) (display ")"))))
  (begin (display "(") (shw-nxt n strm)))
(show-stream-take 30 (fib))
