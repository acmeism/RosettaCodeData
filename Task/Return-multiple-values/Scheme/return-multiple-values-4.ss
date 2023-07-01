(let-values (((sum difference) (addsub 33 12)))
  ; in this scope you can use sum and difference
  (display "33 + 12 = ") (display sum) (newline)
  (display "33 - 12 = ") (display difference) (newline))
