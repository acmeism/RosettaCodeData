#lang racket

(define limit 21)
(define max-resp 3)

(define (get-resp)
  (let loop ()
    (match (read-line)
      [(app (conjoin string? string->number) n)
       #:when (and (exact-integer? n) (<= 1 n max-resp))
       n]
      ["q" (exit)]
      [n (printf "~a is not in range 1 and ~a\n" n max-resp)
         (loop)])))

(define (win human?) (printf "~a wins\n" (if human? "Human" "Computer")))

(printf "The ~a game. Each player chooses to add a number
in range 1 and ~a to a running total.
The player whose turn it is when the total reaches exactly ~a wins.
Enter q to quit.\n\n" limit max-resp limit)

(let loop ([total 0] [human-turn? (= 0 (random 2))])
  (define new-total
    (+ total
       (cond
         [human-turn? (printf "Running total is: ~a\n" total)
                      (printf "Your turn:\n")
                      (get-resp)]
         [else (define resp (random 1 (add1 max-resp)))
               (printf "Computer plays: ~a\n" resp)
               resp])))
  (cond
    [(= new-total limit) (win human-turn?)]
    [(> new-total limit) (win (not human-turn?))]
    [else (loop new-total (not human-turn?))]))
