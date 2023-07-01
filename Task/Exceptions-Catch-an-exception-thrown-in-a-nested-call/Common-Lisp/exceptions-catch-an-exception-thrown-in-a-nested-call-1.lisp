(define-condition user-condition-1 (error) ())
(define-condition user-condition-2 (error) ())

(defun foo ()
  (dolist (type '(user-condition-1 user-condition-2))
    (handler-case
        (bar type)
      (user-condition-1 (c)
        (format t "~&foo: Caught: ~A~%" c)))))

(defun bar (type)
  (baz type))

(defun baz (type)
  (error type))    ; shortcut for (error (make-condition type))

(trace foo bar baz)
(foo)
