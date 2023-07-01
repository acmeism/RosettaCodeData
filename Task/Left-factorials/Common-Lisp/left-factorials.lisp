(defun fact (n)
  (reduce #'* (loop for i from 1 to n collect i)))

(defun left-fac (n)
  (reduce #'+ (loop for i below n collect (fact i))))

(format t "0 -> 10~&")
(format t "~a~&" (loop for i upto 10 collect (left-fac i)))
(format t "20 -> 110 by 10~&")
(format t "~{~a~&~}" (loop for i from 20 upto 110 by 10 collect (left-fac i)))
(format t "1000 -> 10000 by 1000~&")
(format t "~{~a digits~&~}" (loop for i from 1000 upto 10000 by 1000 collect (length (format nil "~a" (left-fac i)))))
