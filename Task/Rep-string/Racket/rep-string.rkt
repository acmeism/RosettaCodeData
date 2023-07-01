#lang racket

(define (rep-string str)
  (define len (string-length str))
  (for/or ([n (in-range 1 len)])
    (and (let loop ([from n])
           (or (>= from len)
               (let ([m (min (- len from) n)])
                 (and (equal? (substring str from (+ from m))
                              (substring str 0 m))
                      (loop (+ n from))))))
         (<= n (quotient len 2))
         (substring str 0 n))))

(for ([str '("1001110011"
             "1110111011"
             "0010010010"
             "1010101010"
             "1111111111"
             "0100101101"
             "0100100"
             "101"
             "11"
             "00"
             "1")])
  (printf "~a => ~a\n" str (or (rep-string str) "not a rep-string")))
