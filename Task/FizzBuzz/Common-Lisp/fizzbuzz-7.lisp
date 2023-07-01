(defun core (x)
  (mapcar
    #'(lambda (a b) (if (equal 0 (mod x a)) b x))
    '(3 5)
    '("fizz" "buzz")))

(defun filter-core (x)
  (if (equal 1 (length (remove-duplicates x)))
    (list (car x))
    (remove-if-not #'stringp x)))

(defun fizzbuzz (x)
  (loop for a from 1 to x do
    (print (format nil "~{~a~}" (filter-core (core a))))))

(fizzbuzz 100)
