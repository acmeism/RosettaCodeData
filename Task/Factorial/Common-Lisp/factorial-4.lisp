;; Project : Factorial
;; Date    : 2018/03/09
;; Author : Gal Zsolt [~ CalmoSoft ~]
;; Email   : <calmosoft@gmail.com>

(defun factorial (n)
          (cond ((= n 1) 1)
          (t (* n (factorial (- n 1))))))
(format t "~a" "factorial of 8: ")
(factorial 8)
