(defun fizzbuzz (n)
  (cond ((and (zerop (% n 5)) (zerop (% n 3))) "FizzBuzz")
	((zerop (% n 3)) "Fizz")
	((zerop (% n 5)) "Buzz")
	(t n)))

;; loop & print from 0 to 100
(dotimes (i 101)
  (message "%s" (fizzbuzz i)))
