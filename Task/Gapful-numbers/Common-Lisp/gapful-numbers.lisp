(defun first-digit (n) (parse-integer (string (char (write-to-string n) 0))))

(defun last-digit (n) (mod n 10))

(defun bookend-number (n) (+ (* 10 (first-digit n)) (last-digit n)))

(defun gapfulp (n) (and (>= n 100) (zerop (mod n (bookend-number n)))))

(defun gapfuls-in-range (start size)
  (loop for n from start
        with include = (gapfulp n)
        counting include into found
        if include collecting n
        until (= found size)))

(defun report-range (range)
  (destructuring-bind (start size) range
    (format t "The first ~a gapful numbers >= ~a:~% ~a~%~%" size start
              (gapfuls-in-range start size))))

(mapcar #'report-range '((1 30) (1000000 15) (1000000000 10)))
