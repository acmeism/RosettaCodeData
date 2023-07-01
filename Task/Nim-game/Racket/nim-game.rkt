#lang racket

(define (print-remaining tokens-remaining)
  (printf "~a tokens remain.\n" tokens-remaining))

(define (read-tokens)
  (define num (read))
  (cond
    [(and (natural? num) (< num 4)) num]
    [else
     (display "Please enter a number between 1 to 3\n")
     (read-tokens)]))

(define (pturn tokens-remaining)
  (cond
    [(not (zero? tokens-remaining))
        (print-remaining tokens-remaining)
        (display "Your turn. How many tokens? ")
        (define n (read-tokens))
        (cturn (- tokens-remaining n) n)]
    [else (display "Computer wins!")]))


(define (cturn tokens-remaining p-took)
  (cond
    [(not (zero? tokens-remaining))
      (print-remaining tokens-remaining)
      (define c-take (- 4 p-took))
      (printf "Computer takes ~a tokens\n" c-take)
      (pturn (- tokens-remaining c-take))]
  [else (display "You win!")]))

(pturn 12)
