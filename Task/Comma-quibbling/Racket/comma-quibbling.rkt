(define (quibbling words)
  (define (sub-quibbling words)
    (match words
      ['() ""]
      [(list a) a]
      [(list a b) (format "~a and ~a" a b)]
      [(list a b ___) (format "~a, ~a" a (sub-quibbling b))]))
  (format "{~a}" (sub-quibbling words)))

(for ((input '([] ["ABC"] ["ABC" "DEF"] ["ABC" "DEF" "G" "H"])))
  (printf "~s\t->\t~a~%" input (quibbling input)))
