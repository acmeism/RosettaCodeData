(defun unfit (s1 s2)
  (loop for a across s1
	for b across s2 count(char/= a b)))

(defun mutate (str alp n) ; n: number of chars to mutate
  (let ((out (copy-seq str)))
    (dotimes (i n) (setf (char out (random (length str)))
			 (char alp (random (length alp)))))
    out))

(defun evolve (changes alpha target)
  (loop for gen from 1
	with f2 with s2
	with str = (mutate target alpha 100)
	with fit = (unfit target str)
	while (plusp fit) do
	(setf s2 (mutate str alpha changes)
	      f2 (unfit target s2))
	(when (> fit f2)
	  (setf str s2 fit f2)
	  (format t "~5d: ~a (~d)~%" gen str fit))))

(evolve 1 " ABCDEFGHIJKLMNOPQRSTUVWXYZ" "METHINKS IT IS LIKE A WEASEL")
