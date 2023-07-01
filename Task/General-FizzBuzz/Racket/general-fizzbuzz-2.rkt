#lang racket
(require racket/match)

(define (fizz-buzz-individual x . args)
  (match (string-append*
          (map (lambda (i)
                 (match i
                   [(cons a b) (if (= 0 (modulo x a)) b "")])) args))
    ["" x]
    [fizz-buzz-string fizz-buzz-string]))

(define (fizz-buzz x . args)
  (map (curryr (compose displayln (curry apply fizz-buzz-individual)) args)
       (range 1 (add1 x)))
  (void))

(fizz-buzz 20 '(3 . "Fizz") '(5 . "Buzz") '(7 . "Baxx"))
