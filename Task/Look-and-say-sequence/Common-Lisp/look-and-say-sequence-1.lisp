(defun compress (array &key (test 'eql) &aux (l (length array)))
  "Compresses array by returning a list of conses each of whose car is
a number of occurrences and whose cdr is the element occurring.  For
instance, (compress \"abb\") produces ((1 . #\a) (2 . #\b))."
  (if (zerop l) nil
    (do* ((i 1 (1+ i))
          (segments (acons 1 (aref array 0) '())))
         ((eql i l) (nreverse segments))
      (if (funcall test (aref array i) (cdar segments))
        (incf (caar segments))
        (setf segments (acons 1 (aref array i) segments))))))

(defun next-look-and-say (number)
  (reduce #'(lambda (n pair)
              (+ (* 100 n)
                 (* 10 (car pair))
                 (parse-integer (string (cdr pair)))))
          (compress (princ-to-string number))
          :initial-value 0))
