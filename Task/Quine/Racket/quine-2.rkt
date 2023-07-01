(module quine racket
  (pretty-write
   ((λ (x) `(module quine racket (pretty-write (,x ',x))))
    '(λ (x) `(module quine racket (pretty-write (,x ',x)))))))
