#lang racket

(struct *straddling (header main original)
  #:reflection-name 'straddling
  #:methods gen:custom-write
  [(define (write-proc board port mode)
     (write-string "#<straddling " port)
     (write (*straddling-original board) port)
     (write-string ">" port))])

(define string->vector (compose list->vector string->list))

(define (straddling . lines)
  (define header-tail (reverse
                       (for/fold ([rev-ret '()])
                                 ([char (in-list (string->list (car lines)))]
                                  [i (in-naturals)])
                         (if (equal? char #\space)
                             (cons (number->string i) rev-ret)
                             rev-ret))))
  (define main (list->vector
                (map string->vector
                     (cons "0123456789"
                           (map string-upcase
                                lines)))))
  (define temporal-board
    (*straddling (list->vector (list* "?" "" header-tail)) main lines))
  (define escape (straddling-encode-char #\/ temporal-board))
  (*straddling (list->vector (list* escape "" header-tail)) main lines))
