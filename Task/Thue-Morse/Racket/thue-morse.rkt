#lang racket
(define 1<->0 (match-lambda [#\0 #\1] [#\1 #\0]))
(define (thue-morse-step (s "0"))
  (string-append s (list->string (map 1<->0 (string->list s)))))

(define (thue-morse n)
  (let inr ((n (max (sub1 n) 0)) (rv (list "0")))
    (if (zero? n) (reverse rv) (inr (sub1 n) (cons (thue-morse-step (car rv)) rv)))))

(for-each displayln (thue-morse 7))
