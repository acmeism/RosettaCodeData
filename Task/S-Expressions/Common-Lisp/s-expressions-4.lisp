(setf unit-tests '(((1 2) (3 4)) (1 2 3 4) ("ab(cd" "mn)op")
		   (1 (2 (3 (4)))) ((1) (2) (3)) ()))

(defun run-tests ()
  (dolist (test unit-tests)
    (format t "Before: ~18s  After: ~s~%"
	    test (write-sexp test))))
