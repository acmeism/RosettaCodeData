(define print-all
  (lambda things
    (for-each
        (lambda (x) (display x) (newline))
        things)))
