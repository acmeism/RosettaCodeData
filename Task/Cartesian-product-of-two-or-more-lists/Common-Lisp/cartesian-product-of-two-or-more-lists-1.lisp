(defun cartesian-product (s1 s2)
  "Compute the cartesian product of two sets represented as lists"
  (loop for x in s1
	nconc (loop for y in s2 collect (list x y))))
