; Chicken Scheme
; read input file as list
(import (chicken io))
(define input  (call-with-input-file "unixdict.txt" (lambda (port) (read-lines port))))

; prime test for number n
(define (prime? n)
  (if (< n 4) (> n 1)
      (and (odd? n)
	   (let loop ((k 3))
	     (or (> (* k k) n)
		 (and (positive? (remainder n k))
		      (loop (+ k 2))))))))

; checks if numbers in list are prime
(define (primal_word lst)
    (do (
        (remaining lst (cdr remaining))
        (final-val #t (prime? (car remaining)))
        )
        ( (or (equal? #f final-val) (null? remaining))
        (if (equal? #f final-val)
        #f
        #t
        ))
        )
)

; convert string to list of ints and check
(for-each
    (lambda (x) (if (primal_word (map char->integer (string->list x)))
        (print x)
        '())
    )
input)

