(defun factorial (x)
  (if (= x 1)
      x
      (* x (factorial (- x 1)))))

(defun is-factor (x y)
  (zerop (mod x y)))

(defun is-prime (n)
  (cond ((< n 4) (or (= n 2) (= n 3)))
        ((or (zerop (mod n 2)) (zerop (mod n 3))) nil)
        (t (loop for i from 5 to (floor (sqrt n)) by 6
                 never (or (is-factor n i)
                           (is-factor n (+ i 2)))))))

(defun main (&optional (limit 10))
  (let ((n 0)
        (f 0))
    (loop while (< n limit)
          for i from 1
          do (setf f (factorial i))
             (when (is-prime (+ f 1))
               (incf n)
               (format t "~2d: ~2d! + 1 = ~12d~%" n i (+ f 1)))
             (when (is-prime (- f 1))
               (incf n)
               (format t "~2d: ~2d! - 1 = ~12d~%" n i (- f 1))))))
