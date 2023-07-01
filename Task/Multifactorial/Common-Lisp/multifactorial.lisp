(defun mfac (n m)
  (reduce #'* (loop for i from n downto 1 by m collect i)))

(loop for i from 1 to 10
      do (format t "~2@a: ~{~a~^ ~}~%"
                 i (loop for j from 1 to 10
                         collect (mfac j i))))
