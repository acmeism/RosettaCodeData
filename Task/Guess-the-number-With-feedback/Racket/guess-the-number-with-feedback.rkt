#lang racket
(define min 1)
(define max 10)

(define (guess-number (target (+ min (random (- max min)))))
  (define guess (read))
  (cond ((not (number? guess)) (display "That's not a number!\n" (guess-number target)))
        ((or (> guess max) (> min guess)) (display "Out of range!\n") (guess-number target))
        ((> guess target) (display "Too high!\n") (guess-number target))
        ((< guess target) (display "Too low!\n") (guess-number target))
        (else (display "Well guessed!\n"))))

(display (format "Guess a number between ~a and ~a\n" min max))
(guess-number)
