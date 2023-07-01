;;A list of unit tests.  Each test is a cons in which the car (left side) contains the
;;test string and the cdr (right side) the expected result of reading the S-Exp.
(setf unit-tests
      (list
       (cons "[]" NIL)
       (cons "[a b c]" '(a b c))
       (cons "[\"abc\" \"def\"]" '("abc" "def"))
       (cons "[1 2 [3 4 [5]]]" '(1 2 (3 4 (5))))
       (cons "[\"(\" 1 2 \")\"]" '("(" 1 2 ")"))
       (cons "[4/8 3/6 2/4]" '(1/2 1/2 1/2))
       (cons "[reduce #'+ '[1 2 3]]" '(reduce #'+ '(1 2 3)))))

(defun run-tests ()
  (dolist (test unit-tests)
    (format t "String: ~23s  Expected: ~23s  Actual: ~s~%"
	    (car test) (cdr test) (read-from-string (car test)))))
