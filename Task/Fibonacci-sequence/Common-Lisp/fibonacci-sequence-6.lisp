(defun fib (n &optional (a 1) (b 0) (p 0) (q 1))
    (if (= n 1) (+ (* b p) (* a q))
     (fib (ash n -1)
          (if (evenp n) a (+ (* b q) (* a (+ p q))))
          (if (evenp n) b (+ (* b p) (* a q)))
          (+ (* p p) (* q q))
          (+ (* q q) (* 2 p q))))) ;p is Fib(2^n-1), q is Fib(2^n).

(print (fib 100000))
