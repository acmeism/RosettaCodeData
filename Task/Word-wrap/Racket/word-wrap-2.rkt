#lang racket

(define (wrap words width)
  (define (maybe-cons xs xss)
    (if (empty? xs) xss (cons xs xss)))
  (match/values
    (for/fold ([lines '()] [line '()] [left width]) ([w words])
      (define n (string-length w))
      (cond
        [(> n width) ; word longer than line => line on its own
         (values (cons (list w) (maybe-cons line lines)) '() width)]
        [(> n left)  ; not enough space left => new line
         (values (cons line lines) (list w) (- width n 1))]
        [else
         (values lines (cons w line) (- left n 1))]))
    [(lines line _)
     (apply string-append
            (for/list ([line (reverse (cons line lines))])
              (string-join line #:after-last "\n")))]))

;;; Usage:
(wrap (string-split text) 70)
