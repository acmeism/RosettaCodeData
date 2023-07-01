(defun approximate-pi (n)
  (/ (loop repeat n count (<= (abs (complex (random 1.0) (random 1.0))) 1.0)) n 0.25))

(dolist (n (loop repeat 5 for n = 1000 then (* n 10) collect n))
  (format t "~%~8d -> ~f" n (approximate-pi n)))
