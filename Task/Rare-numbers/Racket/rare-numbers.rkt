; 20231024 Racket programming naive solution
#lang racket
(require control)
(require text-block/text)

(define (is-palindrome n)
  (define (digit-list n)
    (if (zero? n)
        '()
        (cons (remainder n 10) (digit-list (quotient n 10)))))

  (define (reverse-list lst)
    (if (null? lst)
        '()
        (append (reverse-list (cdr lst)) (list (car lst)))))

  (define digits (digit-list n))
  (equal? digits (reverse-list digits)))

(define (perfect-square? n)
  (if (rational? (sqrt n))
      (= n (expt (floor (sqrt n)) 2))
      false))

(define (reverse-number n)
    (string->number (string-reverse (number->string n))))

(define (find-rare-numbers count)
  (define rare-numbers '())
  (define i 1)

  (define (is-rare? n)
    (and (not (is-palindrome n))
         (let* ((r (reverse-number n))
                (sum (+ n r))
                (diff (- n r)))
           (and (perfect-square? sum)
                (perfect-square? diff)))))

  (define start-time (current-inexact-milliseconds))

  (while (< (length rare-numbers) count)
    (cond [(is-rare? i)
        (displayln (format "Number: ~a | Elapsed time: ~a ms" i (round (- (current-inexact-milliseconds) start-time))))
        (set! rare-numbers (cons i rare-numbers))])
    (set! i (+ i 1)))

  (reverse rare-numbers))

(displayln "The first 5 rare numbers are:")
(for-each (λ (x) (display x) (display "\n")) (find-rare-numbers 5))
