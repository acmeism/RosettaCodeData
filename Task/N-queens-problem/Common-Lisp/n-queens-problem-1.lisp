(defun queens (n &optional (m n))
  (if (zerop n)
      (list nil)
      (loop for solution in (queens (1- n) m)
            nconc (loop for new-col from 1 to m
                         when (loop for row from 1 to n
                                     for col in solution
                                     always (/= new-col col (+ col row) (- col row)))
                         collect (cons new-col solution)))))

(defun print-solution (solution)
  (loop for queen-col in solution
        do (loop for col from 1 to (length solution)
                  do (write-char (if (= col queen-col) #\Q #\.)))
           (terpri))
  (terpri))

(defun print-queens (n)
  (mapc #'print-solution (queens n)))
