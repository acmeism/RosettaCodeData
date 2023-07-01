(defun next-hamm (factors seqs)
  (let ((x (apply #'min (map 'list #'first seqs))))
    (loop for s in seqs
	  for f in factors
	  for i from 0
	  with add = t do
	  (if (= x (first s)) (pop s))
	  ;; prevent a value from being added to multiple lists
	  (when add
	    (setf (elt seqs i) (nconc s (list (* x f))))
	    (if (zerop (mod x f)) (setf add nil)))
    finally (return x))))

(loop with factors = '(2 3 5)
      with seqs    = (loop for i in factors collect '(1))
      for n from 1 to 1000001 do
      (let ((x (next-hamm factors seqs)))
	(if (or (< n 21)
		(= n 1691)
		(= n 1000000)) (format t "~d: ~d~%" n x))))
