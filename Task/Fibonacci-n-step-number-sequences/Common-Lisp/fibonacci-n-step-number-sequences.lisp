(defun gen-fib (lst m)
  "Return the first m members of a generalized Fibonacci sequence using lst as initial values
   and the length of lst as step."
  (let ((l (- (length lst) 1)))
       (do* ((fib-list (reverse lst) (cons (loop for i from 0 to l sum (nth i fib-list)) fib-list))
	     (c (+ l 2) (+ c 1)))
	    ((> c m) (reverse fib-list)))))

(defun initial-values (n)
  "Return the initial values of the Fibonacci n-step sequence"
  (cons 1
        (loop for i from 0 to (- n 2)
              collect (expt 2 i))))

(defun start ()
  (format t "Lucas series: ~a~%" (gen-fib '(2 1) 10))
  (loop for i from 2 to 4
        do (format t "Fibonacci ~a-step sequence: ~a~%" i (gen-fib (initial-values i) 10))))
