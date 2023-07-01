;; Sort criteria is by most significant digit with least digits used as a tie
;; breaker

(defun largest-msd-with-less-digits (x y)
  (flet ((first-digit (x)
           (digit-char-p (aref x 0))))
    (cond ((> (first-digit x)
              (first-digit y))
           t)
          ((> (first-digit y)
              (first-digit x))
           nil)
          ((and (= (first-digit x)
                   (first-digit y))
                (> (length x)
                   (length y)))
           nil)
          (t t))))

(loop
  :for input :in '((54 546 548 60) (1 34 3 98 9 76 45 4))
  :do (format t "~{~A~}~%"
              (sort (mapcar #'write-to-string input)
                    #'largest-msd-with-less-digits)))
