(defun n-ways (n f s &optional (mem (make-array '(999 99) :initial-element -1)))
  (cond ((and (= n 0) (= s 0)) 1)
        ((or (= n 0) (<= s 0)) 0)
        ((>= (aref mem s n) 0) (aref mem s n))
        (t (loop for i from 1 to f
                 sum (n-ways (1- n) f (- s i) mem) into total
                 finally (return (setf (aref mem s n) total))))))

(defun winning-probability (n1 f1 n2 f2 &aux (w 0))
  (loop for i from n1 to (* n1 f1)
        do (loop for j from n2 to (* n2 f2)
                 do (if (> i j)
                        (setf w (+ w (* (n-ways n1 f1 i) (n-ways n2 f2 j))))))
        finally (return (/ w (* (expt f1 n1) (expt f2 n2))))))
