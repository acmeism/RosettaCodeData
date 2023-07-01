(defun f (lst &optional (sum 100) (so-far nil))
 "Takes a list of digits as argument"
  (if (null lst)
    (cond ((= sum 0) (format t "~d = ~{~@d~}~%" (apply #'+ so-far) (reverse so-far)) 1)
          (t 0) )
    (let ((total 0)
          (len (length lst)) )
      (dotimes (i len total)
        (let* ((str1 (butlast lst i))
               (num1 (or (numlist-to-string str1) 0))
               (rem (nthcdr (- len i) lst)) )
          (incf total
            (+ (f rem (- sum num1) (cons num1 so-far))
               (f rem (+ sum num1) (cons (- num1) so-far)) )))))))


(defun numlist-to-string (lst)
 "Convert a list of digits into an integer"
  (when lst
    (parse-integer (format nil "~{~d~}" lst)) ))
