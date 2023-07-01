;; Project : Array length

(setf my-array (make-array '(2)))
(setf (aref my-array 0) "apple")
(setf (aref my-array 1) "orange")
(format t "~a" "length of my-array: ")
(length my-array)
(terpri)
