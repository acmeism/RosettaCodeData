(defun look-and-say (s)
   (let ((out (list (char s 0) 0)))
     (loop for x across s do
	   (if (char= x (first out))
	     (incf (second out))
	     (setf out (list* x 1 out))))
     (format nil "~{~a~^~}" (nreverse out))))

(loop for s = "1" then (look-and-say s)
      repeat 10
      do (write-line s))
