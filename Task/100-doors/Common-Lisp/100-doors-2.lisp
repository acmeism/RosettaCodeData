(define-modify-macro toggle () not)

(defun 100-doors ()
  (let ((doors (make-array 100)))
    (dotimes (i 100)
      (loop for j from i below 100 by (1+ i)
	 do (toggle (svref doors j))))
    (dotimes (i 100)
      (format t "door ~a: ~:[closed~;open~]~%" (1+ i) (svref doors i)))))
