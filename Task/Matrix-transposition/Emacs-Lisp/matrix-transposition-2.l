(defun matrix-transposition (m)
  (apply #'seq-mapn (append (list #'list) m)) )

(let ((m '(( 2  0 -5 -1)
	       (-3 -2 -4  7)
	       (-1 -3  0 -6))))
  (message "%s" (matrix-transposition m)) )
