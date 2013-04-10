#lang racket
#ci(module dogs racket
     (define dog "Benjamin")
     (set! Dog "Samba")
     (set! DOG "Bernie")
     (if (equal? dog DOG)
         (displayln (~a "There is one dog named " DOG "."))
         (displayln (~a "The three dogs are named " dog ", " Dog ", and, " DOG "."))))
(require 'dogs)
