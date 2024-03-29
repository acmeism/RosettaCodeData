(defun fizzbuzz (limit factor-words)
  (loop for i from 1 to limit
     if (assoc-if #'(lambda (factor) (zerop (mod i factor))) factor-words)
     do (loop for (factor . word) in factor-words
           when (zerop (mod i factor)) do (princ word)
           finally (fresh-line))
     else do (format t "~a~%" i)))

(defun read-factors (&optional factor-words)
  (princ "> ")
  (let ((input (read-line t nil)))
    (cond ((zerop (length input))
           (sort factor-words #'< :key #'car))
          ((digit-char-p (char input 0))
           (multiple-value-bind (n i) (parse-integer input :junk-allowed t)
             (read-factors (acons n (string-trim " " (subseq input i))
                                  factor-words))))
          (t (write-line "Invalid input.")
             (read-factors factor-words)))))

(defun main ()
  (loop initially (princ "> ")
     for input = (read-line t nil)
     until (and (> (length input) 0)
                (digit-char-p (char input 0))
                (not (zerop (parse-integer input :junk-allowed t))))
     finally (fizzbuzz (parse-integer input :junk-allowed t) (read-factors))))
