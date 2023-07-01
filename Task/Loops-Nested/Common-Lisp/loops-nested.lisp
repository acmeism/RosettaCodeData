(let ((a (make-array '(10 10))))
  (dotimes (i 10)
    (dotimes (j 10)
      (setf (aref a i j) (1+ (random 20)))))

  (block outer
    (dotimes (i 10)
      (dotimes (j 10)
        (princ " ")
        (princ (aref a i j))
        (if (= 20 (aref a i j))
            (return-from outer)))
      (terpri))
    (terpri)))
