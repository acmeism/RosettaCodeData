(defun max-mismatch (list)
  (if (cdr list)
    (max (apply #'max (mapcar #'(lambda (w2) (mismatch (car list) w2)) (cdr list))) (max-mismatch (cdr list)))
    0 ))

(with-open-file (f "days-of-the-week.txt" :direction :input)
  (do* ((row (read-line f nil nil) (read-line f nil nil)))
       ((null row) t)
    (format t "~d ~a~%" (1+ (max-mismatch (SPLIT-SEQUENCE:split-sequence #\Space row))) row) ))
