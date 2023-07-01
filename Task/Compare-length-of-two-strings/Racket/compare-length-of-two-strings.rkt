#lang racket

(define strings '("abcd" "123456789" "abcdef" "1234567"))

(for ([i (sort strings > #:key string-length)])
  (printf "'~a' is length ~a~n" i (string-length i)))
