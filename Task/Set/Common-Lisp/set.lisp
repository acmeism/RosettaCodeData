(setf a '(1 2 3 4))
(setf b '(2 3 4 5))

(format t "sets: ~a ~a~%" a b)

;;; element
(loop for x from 1 to 6 do
	(format t (if (member x a)
		    "~d ∈ A~%"
		    "~d ∉ A~%") x))

(format t "A ∪ B: ~a~%" (union a b))
(format t "A ∩ B: ~a~%" (intersection a b))
(format t "A \\ B: ~a~%" (set-difference a b))
(format t (if (subsetp a b)
	    "~a ⊆ ~a~%"
	    "~a ⊈ ~a~%") a b)

(format t (if (and (subsetp a b)
		   (subsetp b a))
	    "~a = ~a~%"
	    "~a ≠ ~a~%") a b)
