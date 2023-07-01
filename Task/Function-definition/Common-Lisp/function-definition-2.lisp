(define-compiler-macro multiply (&whole expr a b)
  (if (and (constantp a) (constantp b))
    (* (eval a) (eval b))
    expr)) ;; no macro recursion if we just return expr; the job is done!
