#lang racket

(define (jewels-and-stones stones jewels)
  (length (filter (curryr member (string->list jewels)) (string->list stones))))

(module+ main
  (jewels-and-stones "aAAbbbb" "aA")
  (jewels-and-stones "ZZ" "z"))
