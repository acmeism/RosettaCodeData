(defun fizzbuzz (n)
  (cond ((and
	  (eq (% n 5) 0)
	  (eq (% n 3) 0))  "FizzBuzz")
	((eq (% n 3) 0)  "Fizz")
	((eq (% n 5) 0)  "Buzz")
	(t  n)))

;; loop & print from 0 to 100
(dotimes (i 101) (princ-list (fizzbuzz i)))
