(defun fill-part (x i j l)
  (let ((e (elt x i)))
    (loop for c in l do
	    (loop while (>= j (length e)) do
		  (setf j 0 e (elt x (incf i))))
	    (setf (elt e j) c)
	    (incf j))))

;;; take a list of lists and return next partitioning
;;; it's caller's responsibility to ensure each sublist is sorted
(defun next-part (list cmp)
  (let* ((l (coerce list 'vector))
	 (i (1- (length l)))
	 (e (elt l i)))
    (loop while (<= 0 (decf i)) do
	  ;; e holds all the right most elements
	  (let ((p (elt l i)) (q (car (last e))))
	    ;; find the right-most list that has an element that's smaller
	    ;; than _something_ in later lists
	    (when (and p (funcall cmp (first p) q))
	      ;; find largest element that can be increased
	      (loop for j from (1- (length p)) downto 0 do
		    (when (funcall cmp (elt p j) q)
		      ;; find the smallest element that's larger than
		      ;; that largest
		      (loop for x from 0 to (1- (length e)) do
			    (when (funcall cmp (elt p j) (elt e x))
			      (rotatef (elt p j) (elt e x))
			      (loop while (< (incf j) (length p)) do
			      	(setf (elt p j) (elt e (incf x))
				      (elt e x) nil))
			      (fill-part l i j (remove nil e))
			      (return-from next-part l))))
		    (setf e (append e (list (elt p j))))))
	    (setf e (append e p))))))

(let ((a '#((1 2) () (3 4))))
  (loop while a do
	(format t "~a~%" a)
	(setf a (next-part a #'<))))

(write-line "with dupe elements:")
(let ((a '#((a c) (c c d))))
  (loop while a do
	(format t "~a~%" a)
	(setf a (next-part a #'string<))))
