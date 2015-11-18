(defun transpose (remain &optional (ret '()))
  (if (null remain)
    ret
    (transpose (remove-if #'null (mapcar #'cdr remain))
               (append ret (list (mapcar #'car remain))))))

(defun bead-sort (xs)
  (mapcar #'length (transpose (transpose (mapcar (lambda (x) (make-list x :initial-element 1)) xs)))))

(bead-sort '(5 2 4 1 3 3 9))
