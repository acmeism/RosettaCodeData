((lambda (q) (quasiquote ((unquote q) (quote (unquote q))))) (quote (lambda (q) (quasiquote ((unquote q) (quote (unquote q)))))))
