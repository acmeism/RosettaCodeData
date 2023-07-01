#lang racket/base

(define (get-matches num factors/words)
  (for*/list ([factor/word (in-list factors/words)]
              [factor (in-value (car factor/word))]
              [word (in-value (cadr factor/word))]
              #:when (zero? (remainder num factor)))
    word))

(define (gen-fizzbuzz from to factors/words)
  (for ([num (in-range from to)])
    (define matches (get-matches num factors/words))
    (displayln (if (null? matches)
                  (number->string num)
                  (apply string-append matches)))))

(gen-fizzbuzz 1 21 '((3 "Fizz")
                     (5 "Buzz")
                     (7 "Baxx")))
