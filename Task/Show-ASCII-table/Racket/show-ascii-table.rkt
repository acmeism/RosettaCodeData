#lang racket

(for ([i (in-range 16)])
  (for ([j (in-range 6)])
    (define n (+ 32 (* j 16) i))
    (printf "~a : ~a"
            (~a n #:align 'right #:min-width 3)
            (~a (match n
                  [32 "SPC"]
                  [127 "DEL"]
                  [_ (integer->char n)]) #:min-width 5)))
  (newline))
