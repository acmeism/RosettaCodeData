(declaim (inline no-args))
(declaim (inline one-arg))
(declaim (inline two-args))
(declaim (inline optional-args))

(defun no-args ()
  (format nil "no arguments!"))

(defun one-arg (x)
  ; inserts the value of x into a string
  (format nil "~a" x))

(defun two-args (x y)
  ; same as function `one-arg', but with two arguments
  (format nil "~a ~a" x y))

(defun optional-args (x &optional y) ; optional args are denoted with &optional beforehand
  ; same as function `two-args', but if y is not given it just prints NIL
  (format nil "~a ~a~%" x y))


(no-args) ;=> "no arguments!"

(one-arg 1) ;=> "1"

(two-args 1 "example") ;=> "1 example"

(optional-args 1.0) ;=> "1.0 NIL"

(optional-args 1.0 "example") ;=> "1.0 example"
