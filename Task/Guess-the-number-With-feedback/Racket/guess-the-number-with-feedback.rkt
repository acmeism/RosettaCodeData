#lang racket

(define (guess-number min max)
  (define target (+ min (random (- max min -1))))
  (printf "I'm thinking of a number between ~a and ~a\n" min max)
  (let loop ([prompt "Your guess"])
    (printf "~a: " prompt)
    (flush-output)
    (define guess (read))
    (define response
      (cond [(not (exact-integer? guess)) "Please enter a valid integer"]
            [(< guess target)             "Too low"]
            [(> guess target)             "Too high"]
            [else #f]))
    (when response (printf "~a\n" response) (loop "Try again")))
  (printf "Well guessed!\n"))

(guess-number 1 100)
