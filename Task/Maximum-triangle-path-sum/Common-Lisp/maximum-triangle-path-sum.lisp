(defun find-max-path-sum (s)
  (let ((triangle (loop for line = (read-line s NIL NIL)
                        while line
                        collect (with-input-from-string (str line)
                                  (loop for n = (read str NIL NIL)
                                        while n
                                        collect n)))))
    (flet ((get-max-of-pairs (xs)
             (maplist (lambda (ys)
                        (and (cdr ys) (max (car ys) (cadr ys))))
                      xs)))
      (car (reduce (lambda (xs ys)
                     (mapcar #'+ (get-max-of-pairs xs) ys))
                   (reverse triangle))))))

(defparameter *small-triangle*
  "    55
     94 48
    95 30 96
  77 71 26 67")
(format T "~a~%" (with-input-from-string (s *small-triangle*)
                   (find-max-path-sum s)))
(format T "~a~%" (with-open-file (f "triangle.txt")
                   (find-max-path-sum f)))
