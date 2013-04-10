#lang racket

(define (random-4)
  (sort (for/list ((i (in-range 4)))
          (add1 (random 9)))
        <))

(define (check-valid-chars lst-nums str)
  (define regx (string-join (list
                             "^["
                             (string-join (map number->string lst-nums) "")
                             "\\(\\)\\+\\-\\/\\*\\ ]*$")
                            ""))
  (regexp-match? regx str))

(define (check-all-numbers lst-nums str)
  (equal?
   (sort
    (map (λ (x) (string->number x))
         (regexp-match* "([0-9])" str)) <)
   lst-nums))

(define (start-game)
  (display "** 24 **\n")
  (display "Input \"q\" to quit or your answer in Racket ")
  (display "notation, like (- 1 (* 3 2))\n\n")
  (new-question))

(define (new-question)
  (define numbers (random-4))
  (apply printf "Your numbers: ~a - ~a - ~a - ~a\n" numbers)
  (define (do-loop)
    (define user-expr (read-line))
    (cond
      [(equal? user-expr "q")
       (exit)]
      [(not (check-valid-chars numbers user-expr))
       (display "Your expression seems invalid, please retry:\n")
       (do-loop)]
      [(not (check-all-numbers numbers user-expr))
       (display "You didn't use all the provided numbers, please retry:\n")
       (do-loop)]
      [(if (equal? 24 (eval (with-input-from-string user-expr read) (make-base-namespace)))
           (display "OK!!")
           (begin
             (display "Incorrect\n")
             (do-loop)))]))
  (do-loop))

(start-game)
