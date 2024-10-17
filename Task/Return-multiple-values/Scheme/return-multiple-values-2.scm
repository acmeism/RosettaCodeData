(call-with-values
  (lambda () (addsub 33 12))
  (lambda (sum difference)
    (display "33 + 12 = ") (display sum) (newline)
    (display "33 - 12 = ") (display difference) (newline)))
