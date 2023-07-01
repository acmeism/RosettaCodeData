(defun fast-fib-r (n a b)
   (if (or (zp n) (zp (1- n)))
       b
       (fast-fib-r (1- n) b (+ a b))))

(defun fast-fib (n)
   (fast-fib-r n 1 1))

(defun first-fibs-r (n i)
   (declare (xargs :measure (nfix (- n i))))
   (if (zp (- n i))
       nil
       (cons (fast-fib i)
             (first-fibs-r n (1+ i)))))

(defun first-fibs (n)
   (first-fibs-r n 0))
