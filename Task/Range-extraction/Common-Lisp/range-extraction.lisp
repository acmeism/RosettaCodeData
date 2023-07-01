(defun format-with-ranges (list)
  (unless list (return ""))
  (with-output-to-string (s)
    (let ((current (first list))
          (list    (rest list))
          (count   1))
      (princ current s)
      (dolist (next list)
        (if (= next (1+ current))
            (incf count)
            (progn (princ (if (> count 2) "-" ",") s)
                   (when (> count 1)
                     (princ current s)
                     (princ "," s))
                   (princ next s)
                   (setf count 1)))
        (setf current next))
      (when (> count 1)
        (princ (if (> count 2) "-" ",") s)
        (princ current s)))))

CL-USER> (format-with-ranges (list 0  1  2  4  6  7  8 11 12 14
                                   15 16 17 18 19 20 21 22 23 24
                                   25 27 28 29 30 31 32 33 35 36
                                   37 38 39))
"0-2,4,6-8,11,12,14-25,27-33,35-39"
