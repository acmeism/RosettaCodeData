#!/bin/sh
#|
exec racket -tm- "$0" "$@"
|#

#lang racket

(define (even k)
  (define c (read-char))
  (cond [(eq? c eof) (k)]
        [(not (char-alphabetic? c)) (k) (write-char c) (odd)]
        [else (even (λ() (write-char c) (k)))]))

(define (odd)
  (define c (read-char))
  (unless (eq? c eof)
    (write-char c)
    (if (char-alphabetic? c) (odd) (even void))))

(provide main)
(define (main) (odd) (newline))

;; (with-input-from-string "what,is,the;meaning,of:life." main)
;; ;; -> what,si,the;gninaem,of:efil.
;; (with-input-from-string "we,are;not,in,kansas;any,more." main)
;; ;; -> we,era;not,ni,kansas;yna,more.
