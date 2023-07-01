(defun cubep (n)
   (loop for i from 1
         for c = (* i i i)
         while (<= c n)
         when (= c n) do (return t)
         finally (return nil)))

(defparameter squares (let ((n 0)) (lambda () (incf n) (* n n))))

(destructuring-bind (noncubes cubes)
   (loop for s = (funcall squares) then (funcall squares)
         while (< (length noncubes) 30)
         if (cubep s) collect s into cubes
         if (not (cubep s)) collect s into noncubes
         finally (return (list noncubes cubes)))
   (format t "Squares but not cubes:~%~A~%~%" noncubes)
   (format t "Both squares and cubes:~%~A~%~%" cubes))
