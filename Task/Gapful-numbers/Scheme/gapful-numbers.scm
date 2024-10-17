(define (first-digit n) (string->number (string (string-ref (number->string n) 0))))
(define (last-digit n) (modulo n 10))
(define (bookend-number n) (+ (* 10 (first-digit n)) (last-digit n)))
(define (gapful? n) (and (>= n 100) (zero? (modulo n (bookend-number n)))))

(define (gapfuls-in-range start size)
  (let ((found 0) (result '()))
    (do ((n start (+ n 1))) ((>= found size) (reverse result))
      (if (gapful? n)
        (begin (set! result (cons n result)) (set! found (+ found 1)))))))

(define (report-range range)
  (apply (lambda (start size)
    (newline)
    (display "The first ")(display size)(display " gapful numbers >= ")
    (display start)(display ":")(newline)
    (display (gapfuls-in-range start size))(newline)) range))

(map report-range '((100 30) (1000000 15) (1000000000 10)))
