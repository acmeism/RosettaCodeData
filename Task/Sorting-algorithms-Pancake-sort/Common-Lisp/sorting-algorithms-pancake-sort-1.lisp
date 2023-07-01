(defun pancake-sort (seq)
  "A destructive version of Pancake Sort that works with either lists or arrays of numbers."
  (defun flip (lst index)
    (setf (subseq lst 0 index) (reverse (subseq lst 0 index))))
  (loop with lst = (coerce seq 'list)
	for i from (length lst) downto 2
	for index = (position (apply #'max (subseq lst 0 i)) lst)
	do (unless (= index 0)
	     (flip lst (1+ index)))
	(flip lst i)
	finally (return (coerce lst (type-of seq)))))
