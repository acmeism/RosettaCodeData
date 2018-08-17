;; Project : Associative array/Iteration

(setf x (make-array '(3 2)
           :initial-contents '(("hello" 13 ) ("world" 31) ("!" 71))))
(setf xlen (array-dimensions x))
(setf len (car xlen))
(dotimes (n len)
               (terpri)
               (format t "~a" (aref x n 0))
               (format t "~a" " : ")
               (format t "~a" (aref x n 1)))
