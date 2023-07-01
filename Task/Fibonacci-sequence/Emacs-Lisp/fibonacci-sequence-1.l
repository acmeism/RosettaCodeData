(defun fib (n a b c)
  (cond
   ((< c n) (fib n b (+ a b) (+ 1 c)))
   ((= c n) b)
   (t a)))

(defun fibonacci (n)
  (if (< n 2)
      n
    (fib n 0 1 1)))
