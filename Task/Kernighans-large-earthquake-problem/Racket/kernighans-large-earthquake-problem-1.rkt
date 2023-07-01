#lang racket

(with-input-from-file "data/large-earthquake.txt"
  (λ ()
    (for ((s (in-port read-line))
          #:when (> (string->number (third (string-split s))) 6))
    (displayln s))))
