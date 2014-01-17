(defun fibonacci-iterative (n &aux (f0 0) (f1 1))
  (case n
    (0 f0)
    (1 f1)
    (t (loop for n from 2 to n
             for a = f0 then b and b = f1 then result
             for result = (+ a b)
             finally (return result)))))
