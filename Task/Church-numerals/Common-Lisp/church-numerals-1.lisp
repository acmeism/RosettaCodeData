(defvar zero (lambda (f x) x))

(defun succ (n) (lambda (f x) (funcall f (funcall n f x))))

(defun plus (m n)
  (lambda (f x) (funcall m f (funcall n f x))))

(defun times (m n)
  (funcall n (lambda (sum) (plus m sum)) zero))

(defun power (m n)
  (funcall n (lambda (product) (times m product)) one))

(defun church (i)    ; int -> Church
  (if (zerop i) zero (succ (church (1- i)))))

(defun unchurch (n)  ; Church -> int
  (funcall n #'1+ 0))

(defun show (example)
  (format t "~(~S => ~S~)~%"
          example (unchurch (eval example))))

(defvar one (succ zero))
(defvar two (succ one))
(defvar three (succ two))
(defvar four (succ three))

(show '(church 3))
(show '(plus three four))
(show '(times three four))
(show '(power three four))
(show '(power four three))
(show '(power (power two two) (plus two one)))
