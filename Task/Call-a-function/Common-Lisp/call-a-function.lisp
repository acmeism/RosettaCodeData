;Calling a function that requires no arguments
(defun a () "This is the 'A' function")
(a)
;Calling a function with a fixed number of arguments
(defun b (x y) (list x y))
(b 1 2)
;Calling a function with optional arguments
(defun c (&optional x y) (list x y))
(c 1)
;Calling a function with a variable number of arguments
(defun d (&rest args) args)
(d 1 2 3 4 5 6 7 8)
;Calling a function with named arguments
(defun e (&key (x 1) (y 2)) (list x y))
(e :x 10 :y 20)
;Using a function in first-class context within an expression
(defun f (func) (funcall func))
(f #'a)
;Obtaining the return value of a function
(defvar return-of-a (a))
;Is partial application possible and how
(defun curry (function &rest args-1)
  (lambda (&rest args-2)
    (apply function (append args-1 args-2))))
(funcall (curry #'+ 1) 2)
