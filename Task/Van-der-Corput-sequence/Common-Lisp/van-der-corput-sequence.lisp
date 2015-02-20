(defun van-der-Corput (n base)
  (loop for d = 1 then (* d base) while (<= d n)
	finally
	(return (/ (parse-integer
		     (reverse (write-to-string n :base base))
		     :radix base)
		   d))))

(loop for base from 2 to 5 do
      (format t "Base ~a: ~{~6a~^~}~%" base
	      (loop for i to 10 collect (van-der-Corput i base))))
