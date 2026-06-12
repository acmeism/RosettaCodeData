#lang racket

(define user-input
  (~a "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 "
      "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"))

(define content (file->string "theRaven.txt"))

(define (decode slice)
  (match-define (list ff lf tb sp) slice)
  (let loop ([f 0] [l 0] [t 0] [s 0] [xs (string->list content)])
    (define next (curryr loop (rest xs)))
    (match (first xs)
      [c #:when (and (= f ff) (= l lf) (= t tb) (= s sp)) c]
      [#\u000c   (next (add1 f) 0 0 0)]
      [#\newline (next f (add1 l) 0 0)]
      [#\tab     (next f l (add1 t) 0)]
      [_         (next f l t (add1 s))])))

(for ([slice (in-slice 4 (map string->number (string-split user-input)))])
  (define c (decode slice))
  #:break (char=? #\! c)
  (display c))
