(import (scheme base)
        (scheme write)
        (srfi 1))

(define (multi-factorial n m)
  (fold * 1 (iota (ceiling (/ n m)) n (- m))))

(for-each
  (lambda (degree)
    (display (string-append "degree "
                            (number->string degree)
                            ": "))
    (for-each
      (lambda (num)
        (display (string-append (number->string (multi-factorial num degree))
                                " ")))
      (iota 10 1))
    (newline))
  (iota 5 1))
