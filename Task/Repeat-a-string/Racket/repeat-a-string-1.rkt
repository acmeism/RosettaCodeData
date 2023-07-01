#lang racket
;; fast
(define (string-repeat n str)
  (string-append* (make-list n str)))
(string-repeat 5 "ha") ; => "hahahahaha"
