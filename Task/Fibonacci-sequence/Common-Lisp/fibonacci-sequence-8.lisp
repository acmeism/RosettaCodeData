(defmethod fib (n)
  (declare ((integer 0 *) n))
  (+ (fib (- n 1))
     (fib (- n 2))))

(defmethod fib ((n (eql 0))) 0)

(defmethod fib ((n (eql 1))) 1)
