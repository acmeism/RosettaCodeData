#lang racket

(inexact->exact 0.75)  ; -> 3/4
(exact->inexact 3/4)   ; -> 0.75

(exact->inexact 67/74) ; -> 0.9054054054054054
(inexact->exact 0.9054054054054054) ;-> 8155166892806033/9007199254740992
