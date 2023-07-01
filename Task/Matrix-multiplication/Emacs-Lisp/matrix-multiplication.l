(let ()
  (defun matrices-multiply (m1 m2)
    (let (fn-row-mult)
      (setq fn-row-mult
	    (lambda (row col-idx)
	      (let ((col (cl-loop for m2-row in m2
				  collect (nth col-idx m2-row))))
		
		(apply '+ (cl-loop for v1 in row for v2 in col
				   collect (* v1 v2))) ) ) )

      (cl-loop for m1-row in m1 collect
	       (seq-map-indexed (lambda (v col-idx)
				  (funcall fn-row-mult m1-row col-idx) )
				(nth 0 m2) ) ) ) )

  (let ((m1 '((2 1 4)
	      (0 1 1)))
	(m2 '((6 3 -1 0)
	      (1 1 0 4)
	      (-2 5 0 2)))
	result-matrix)

    (switch-to-buffer-other-window "**matrix-result**")
    (erase-buffer)
    (setq result-matrix (matrices-multiply m1 m2))
    (cl-loop for line in result-matrix do
	     (insert (format "%s\n"
			     (apply 'concat
				    (seq-map (lambda (item) (format "%5s " item)) line) ) ) ) ) )

  )
