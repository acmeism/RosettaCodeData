(defun start ()
  (loop for k from 1 to 5
    do (format t "k = ~a: ~a~%" k (collect-k-almost-prime k))))

(defun collect-k-almost-prime (k &optional (d 2) (lst nil))
  (cond ((= (length lst) 10) (reverse lst))
        ((= (?-primality d) k) (collect-k-almost-prime k (+ d 1) (cons d lst)))
        (t (collect-k-almost-prime k (+ d 1) lst))))

(defun ?-primality (n &optional (d 2) (c 0))
  (cond ((> d (isqrt n)) (+ c 1))
        ((zerop (rem n d)) (?-primality (/ n d) d (+ c 1)))
        (t (?-primality n (+ d 1) c))))
