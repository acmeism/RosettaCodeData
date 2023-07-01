(defun pythagorean-triples (n)
  (loop for x from 1 to n
        append (loop for y from x to n
                     append (loop for z from y to n
                                  when (= (+ (* x x) (* y y)) (* z z))
                                  collect (list x y z)))))
