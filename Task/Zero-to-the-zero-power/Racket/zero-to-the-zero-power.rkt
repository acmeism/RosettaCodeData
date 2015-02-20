#lang racket
;; as many zeros as I can think of...
(define zeros (list
               0  ; unspecified number type
               0. ; hinted as float
               #e0 ; explicitly exact
               #i0 ; explicitly inexact
               0+0i ; exact complex
               0.+0.i ; float inexact
               ))
(for*((z zeros) (p zeros))
  (printf "(~a)^(~a) = ~s~%" z p
  (with-handlers [(exn:fail:contract:divide-by-zero? exn-message)]
    (expt z p))))
