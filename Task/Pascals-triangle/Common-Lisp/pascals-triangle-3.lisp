(defun next-pascal-triangle-row (list)
  `(1
    ,.(mapcar #'+ list (rest list))
    1))

(defun pascal-triangle (number-of-rows)
  (loop repeat number-of-rows
        for row = '(1) then (next-pascal-triangle-row row)
        collect row))

(defun print-pascal-triangle (number-of-rows)
  (let* ((triangle (pascal-triangle number-of-rows))
         (max-row-length (length (write-to-string (first (last triangle))))))
    (format t
            (format nil "~~{~~~D:@<~~{~~A ~~}~~>~~%~~}" max-row-length)
            triangle)))
