(defun convert-to-row-echelon-form (matrix)
  (let* ((dimensions (array-dimensions matrix))
	 (row-count (first dimensions))
	 (column-count (second dimensions))
	 (lead 0))
    (labels ((find-pivot (start lead)
	       (let ((i start))
		 (loop
		    :while (zerop (aref matrix i lead))
		    :do (progn
			  (incf i)
			  (when (= i row-count)
			    (setf i start)
			    (incf lead)
			    (when (= lead column-count)
			      (return-from convert-to-row-echelon-form matrix))))
		    :finally (return (values i lead)))))
	     (swap-rows (r1 r2)
	       (loop
		  :for c :upfrom 0 :below column-count
		  :do (rotatef (aref matrix r1 c) (aref matrix r2 c))))
	     (divide-row (r value)
	       (loop
		  :for c :upfrom 0 :below column-count
		  :do (setf (aref matrix r c)
			    (/ (aref matrix r c) value)))))
      (loop
	 :for r :upfrom 0 :below row-count
	 :when (<= column-count lead)
	 :do (return matrix)
	 :do (multiple-value-bind (i nlead) (find-pivot r lead)
	       (setf lead nlead)
	       (swap-rows i r)
	       (divide-row r (aref matrix r lead))
	       (loop
		  :for i :upfrom 0 :below row-count
		  :when (/= i r)
		  :do (let ((scale (aref matrix i lead)))
			(loop
			   :for c :upfrom 0 :below column-count
			   :do (decf (aref matrix i c)
				     (* scale (aref matrix r c))))))
	       (incf lead))
	 :finally (return matrix)))))
