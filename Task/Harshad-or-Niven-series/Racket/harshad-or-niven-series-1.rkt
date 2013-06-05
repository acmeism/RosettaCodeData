#lang racket

(define (digsum n)
  (for/sum ([c (number->string n)]) (string->number [string c])))

(define harshads
  (stream-filter (λ (n) (= (modulo n (digsum n)) 0)) (in-naturals 1)))

; First 20 harshad numbers
(displayln (for/list ([i 20]) (stream-ref harshads i)))

; First harshad greater than 1000
(displayln (for/first ([h harshads] #:when(> h 1000)) h))
