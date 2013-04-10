(defun string-of-brackets (n)
  (let ((result (make-string (* 2 n)))
        (opening n)
        (closing n))
    (dotimes (i (* 2 n) result)
      (setf (aref result i)
            (cond
              ((zerop opening) #\])
              ((zerop closing) #\[)
              (t (if (= (random 2) 0)
                     (progn (decf opening) #\[)
                     (progn (decf closing) #\]))))))))

(defun balancedp (string)
  (zerop (reduce (lambda (nesting bracket)
                   (ecase bracket
                     (#\] (if (= nesting 0)
                              (return-from balancedp nil)
                              (1- nesting)))
                     (#\[ (1+ nesting))))
                 string
                 :initial-value 0)))

(defun show-balanced-brackets ()
  (dotimes (i 10)
    (let ((s (string-of-brackets i)))
      (format t "~3A: ~A~%" (balancedp s) s))))
