#lang racket/base
(require racket/string
         racket/list)

(define (permutations-getall items size)
  (if (zero? size)
      '(())
      (for/list ([tail (in-list (permutations-getall items (- size 1)))]
                  #:when #t
                  [i (in-list items)]
                  #:unless (member i tail))
        (cons i tail))))

(define digits  (list 1 2 3 4 5 6 7 8 9))

(define size 4)

(define all-choices (shuffle (permutations-getall digits size)))

(define (listnum->string list)
  (apply string-append (map number->string list)))
