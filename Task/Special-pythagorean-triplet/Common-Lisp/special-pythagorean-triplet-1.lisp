(defun special-triple (sum)
  (loop
     for a from 1
     do (loop
           for b from (1+ a)
           for c = (- sum a b)
           when (< c b) do (return)
           when (= (* c c) (+ (* a a) (* b b)))
           do (return-from conventional-triple-search (list a b c)))))
