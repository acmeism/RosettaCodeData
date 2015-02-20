(defun mdr/p (n)
  "Return a list with MDR and MP of n"
  (if (< n 10)
    (list n 0)
    (mdr/p-aux n 1 1)))

(defun mdr/p-aux (n a c)
  (cond ((and (zerop n) (< a 10)) (list a c))
	((zerop n) (mdr/p-aux a 1 (+ c 1)))
	(t (mdr/p-aux (floor n 10) (* (rem n 10) a) c))))

(defun first-n-number-for-each-root (n &optional (r 0) (lst nil) (c 0))
  "Return the first m number with MDR = 0 to 9"
  (cond ((and (= (length lst) n) (= r 9)) (format t "~3@a: ~a~%" r (reverse lst)))
	((= (length lst) n) (format t "~3@a: ~a~%" r (reverse lst))
	                    (first-n-number-for-each-root n (+ r 1) nil 0))
	((= (first (mdr/p c)) r) (first-n-number-for-each-root n r (cons c lst) (+ c 1)))
	(t (first-n-number-for-each-root n r lst (+ c 1)))))

(defun start ()
  (format t "Number: MDR  MD~%")
  (loop for el in '(123321 7739 893 899998)
        do (format t "~6@a: ~{~3@a ~}~%" el (mdr/p el)))
  (format t "~%MDR: [n0..n4]~%")
  (first-n-number-for-each-root 5))
