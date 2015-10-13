(defun fib (n a b c)
  (if (< c n) (fib n b (+ a b) (+ 1 c) )
    (if (= c n) b a) ))

(defun fibonacci (n) (if (< n 2) n (fib n 0 1 1) ))
