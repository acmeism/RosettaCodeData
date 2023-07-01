(defun lis-patience-sort (input-list)
  (let ((piles nil))
    (dolist (item input-list)
      (setf piles (insert-item item piles)))
    (reverse (caar (last piles)))))

(defun insert-item (item piles)
  (let ((not-found t))
    (loop
       while not-found
       for pile in piles
       and prev = nil then pile
       and i from 0
       do (when (<= item (caar pile))
	    (setf (elt piles i) (push (cons item (car prev)) (elt piles i))
		  not-found nil)))
    (if not-found
	(append piles (list (list (cons item (caar (last piles))))))
 	piles)))

(dolist (l (list (list 3 2 6 4 5 1)
		   (list 0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15)))
    (format t "~A~%" (lis-patience-sort l)))
