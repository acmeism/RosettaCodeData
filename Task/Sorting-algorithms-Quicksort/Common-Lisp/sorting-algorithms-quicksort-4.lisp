(defun quicksort (list)
  (when list
    (destructuring-bind (x . xs) list
      (nconc (quicksort (remove-if (lambda (a) (> a x)) xs))
	     `(,x)
	     (quicksort (remove-if (lambda (a) (<= a x)) xs))))))
