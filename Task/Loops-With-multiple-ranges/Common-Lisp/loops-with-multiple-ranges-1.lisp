(let ((prod 1)				; Initialize aggregator
      (sum 0)
      (x 5)				; Initialize variables
      (y -5)
      (z -2)
      (one 1)
      (three 3)
      (seven 7))

  (flet ((loop-body (j)			; Set the loop function
	    (incf sum (abs j))
	    (if (and (< (abs prod) (expt 2 27))
		     (/= j 0))
		(setf prod (* prod j)))))

    (do ((i (- three) (incf i three)))	; Just a serie of individual loops
	((> i (expt 3 3)))
      (loop-body i))
    (do ((i (- seven) (incf i x)))
	((> i seven))
      (loop-body i))
    (do ((i 555 (incf i -1)))
	((< i (- 550 y)))
      (loop-body i))
    (do ((i 22 (incf i (- three))))
	((< i -28))
      (loop-body i))
    (do ((i 1927 (incf i)))
	((> i 1939))
      (loop-body i))
    (do ((i x (incf i z)))
	((< i y))
      (loop-body i))
    (do ((i (expt 11 x) (incf i)))
	((> i (+ (expt 11 x) one)))
      (loop-body i)))

  (format t "~&sum  = ~14<~:d~>" sum)
  (format t "~&prod = ~14<~:d~>" prod))
