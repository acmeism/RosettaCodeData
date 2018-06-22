;; Project : Fibonacci sequence
;; Date    : 2018/03/05
;; Author : Gal Zsolt [~ CalmoSoft ~]
;; Email   : <calmosoft@gmail.com

(defun fibonacci (nr)
           (cond ((= nr 0) 1)
           ((= nr 1) 1)
           (t (+ (fibonacci (- nr 1))
           (fibonacci (- nr 2))))))
(format t "~a" "First 10 Fibonacci numbers")
(dotimes (n 10)
(if (< n 1) (terpri))
(if (< n 9) (format t "~a" " "))
(write(+ n 1)) (format t "~a" ": ")
(write (fibonacci n)) (terpri))
