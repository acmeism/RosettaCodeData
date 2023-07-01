(defun s-n-creator (n)
  (let ((sample (make-array n :initial-element nil))
        (i 0))
    (lambda (item)
      (if (<= (incf i) n)
          (setf (aref sample (1- i)) item)
        (when (< (random i) n)
          (setf (aref sample (random n)) item)))
      sample)))

(defun algorithm-s ()
  (let ((*random-state* (make-random-state t))
        (frequency (make-array '(10) :initial-element 0)))
    (loop repeat 100000
          for s-of-n = (s-n-creator 3)
          do (flet ((s-of-n (item)
                      (funcall s-of-n item)))
               (map nil
                    (lambda (i)
                      (incf (aref frequency i)))
                    (loop for i from 0 below 9
                          do (s-of-n i)
                          finally (return (s-of-n 9))))))
    frequency))

(princ (algorithm-s))
