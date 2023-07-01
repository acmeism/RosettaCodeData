;;;; This code implements the foo and bar functions

;;; The foo function calls bar on the first argument and multiplies the result by the second.
;;; The arguments are two integers
(defun foo (a b)
   ;; Call bar and multiply
   (* (bar a) ; Calling bar
      b))

;;; The bar function simply adds 3 to the argument
(defun bar (n)
   (+ n 3))
