(defun 9-billion-names (row column)
  (cond ((<= row 0) 0)
        ((<= column 0) 0)
	((< row column) 0)
	((equal row 1) 1)
	(t (let ((addend (9-billion-names (1- row) (1- column)))
		 (augend (9-billion-names (- row column) column)))
	     (+ addend augend)))))
			
(defun 9-billion-names-triangle (rows)
  (loop for row from 1 to rows
     collect (loop for column from 1 to row
		collect (9-billion-names row column))))

(9-billion-names-triangle 25)
