#lang racket

(define (guess low high)
  (define (input-loop available)
    (define input (car (string->list (symbol->string (read)))))
    (if (member input available)
        input
        (begin
          (printf "Invalid Input\n") (input-loop available))))

  (define (guess-loop low high)
    (define guess (floor (/ (+ low high) 2)))
    (printf "My guess is ~a.\n" guess)
    (define input (input-loop (list #\c #\l #\h)))
    (case input
      ((#\c) (displayln "I knew it!\n"))
      ((#\l) (guess-loop low (sub1 guess)))
      ((#\h) (guess-loop (add1 guess) high))))

  (printf "Think of a number between ~a and ~a.
Use (h)igh, (l)ow and (c)orrect to guide me.\n" low high)
  (guess-loop low high))
