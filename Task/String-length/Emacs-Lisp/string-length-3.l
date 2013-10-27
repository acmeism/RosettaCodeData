(let ((str (apply 'string
                  (mapcar (lambda (c) (decode-char 'ucs c))
                          '(#x1112 #x1161 #x11ab #x1100 #x1173 #x11af)))))
  (list (length str)
        (string-bytes str)
        (string-width str)))
=> (6 18 4)  ;; in emacs 23 up
