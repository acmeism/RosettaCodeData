;; Project : Associative array/Iteration
;; Date    : 2018/03/08
;; Author : Gal Zsolt [~ CalmoSoft ~]
;; Email   : <calmosoft@gmail.com>

(setf x (make-array '(3 2)
           :initial-contents '(("hello" 13 ) ("world" 31) ("!" 71))))
(setf xlen (array-dimensions x))
(setf len (car xlen))
(dotimes (n len)
               (terpri)
               (format t "~a" (aref x n 0))
               (format t "~a" " : ")
               (format t "~a" (aref x n 1)))
