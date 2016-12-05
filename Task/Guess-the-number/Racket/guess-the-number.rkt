#lang racket
(define (guess-number)
  (define number (add1 (random 10)))
  (let loop ()
    (define guess (read))
    (if (equal? guess number)
        (display "Well guessed!\n")
        (loop))))
