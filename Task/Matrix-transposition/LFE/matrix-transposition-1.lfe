(defun transpose (matrix)
  (transpose matrix '()))

(defun transpose (matrix acc)
  (cond
    ((lists:any
        (lambda (x) (== x '()))
        matrix)
     acc)
    ('true
      (let ((heads (lists:map #'car/1 matrix))
            (tails (lists:map #'cdr/1 matrix)))
        (transpose tails (++ acc `(,heads)))))))
