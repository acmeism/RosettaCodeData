#lang racket
(require (planet neil/csv:1:=7) net/url)

(define make-reader
  (make-csv-reader-maker
   '((separator-chars              #\,)
     (strip-leading-whitespace?  . #t)
     (strip-trailing-whitespace? . #t))))

(define (all-rows port)
  (define read-row (make-reader port))
  (define head (append (read-row) '("SUM")))
  (define rows (for/list ([row (in-producer read-row '())])
                 (define xs (map string->number row))
                 (append row (list (~a (apply + xs))))))
  (define (->string row) (string-join row "," #:after-last "\n"))
  (string-append* (map ->string (cons head rows))))
