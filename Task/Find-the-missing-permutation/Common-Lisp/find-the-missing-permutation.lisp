(defparameter *permutations*
  '("ABCD" "CABD" "ACDB" "DACB" "BCDA" "ACBD" "ADCB" "CDAB" "DABC" "BCAD" "CADB" "CDBA"
    "CBAD" "ABDC" "ADBC" "BDCA" "DCBA" "BACD" "BADC" "BDAC" "CBDA" "DBCA" "DCAB"))

(defun missing-perm (perms)
  (let* ((letters (loop for i across (car perms) collecting i))
	 (l (/ (1+ (length perms)) (length letters))))
    (labels ((enum (n) (loop for i below n collecting i))
	     (least-occurs (pos)
	       (let ((occurs (loop for i in perms collecting (aref i pos))))
		 (cdr (assoc (1- l) (mapcar #'(lambda (letter)
						(cons (count letter occurs) letter))
					    letters))))))
      (concatenate 'string (mapcar #'least-occurs (enum (length letters)))))))
