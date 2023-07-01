(defun print-carpet (order)
  (let ((size (expt 3 order)))
    (flet ((trinary (x) (format nil "~3,vR" order x))
           (ones (a b) (and (eql a #\1) (eql b #\1))))
      (loop for i below size do
        (fresh-line)
        (loop for j below size do
          (princ (if (some #'ones (trinary i) (trinary j))
                   " "
                   "#")))))))
