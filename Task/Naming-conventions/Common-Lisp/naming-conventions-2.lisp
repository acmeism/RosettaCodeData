(defun do-something (argument &key ((secret-arg secret) "default"))
   (format t "Argument is ~a, secret is ~a" argument secret))

;; Normal caller
(do-something "Foo")
;; Special caller:
(do-something "Foo" 'secret-arg "Bar")
