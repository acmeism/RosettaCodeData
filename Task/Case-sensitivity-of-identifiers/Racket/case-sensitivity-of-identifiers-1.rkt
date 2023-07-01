#lang racket
(define dog "Benjamin")
(define Dog "Samba")
(define DOG "Bernie")

(if (equal? dog DOG)
    (displayln (~a "There is one dog named " DOG "."))
    (displayln (~a "The three dogs are named " dog ", " Dog ", and, " DOG ".")))
