(with-input-from-string "foobar"
  (lambda ()
    (port-fold (lambda (x s)
                 (alist-update x
                               (add1 (alist-ref x s eq? 0))
                               s))
               '()
               read-char)))
