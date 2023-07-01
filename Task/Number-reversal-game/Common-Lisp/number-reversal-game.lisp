(defun shuffle! (vector)
  (loop for i from (1- (length vector)) downto 1
       do (rotatef (aref vector i)
                   (aref vector (random i)))))

(defun slice (vector start &optional end)
  (let ((end (or end (length vector))))
    (make-array (- end start)
                :element-type (array-element-type vector)
                :displaced-to vector
                :displaced-index-offset start)))

(defun orderedp (seq)
  (apply #'<= (coerce seq 'list)))

(defun prompt-integer (prompt)
  (format t "~A: " prompt)
  (finish-output)
  (clear-input)
  (parse-integer (read-line)))

(defun game ()
  (let ((numbers (vector 1 2 3 4 5 6 7 8 9)))
    (shuffle! numbers)
    (let ((score
           (do ((score 0 (1+ score)))
               ((orderedp numbers) score)
             (format t "~A~%" numbers)
             (let* ((n (prompt-integer "How many numbers to reverse"))
                    (slice (slice numbers 0 n)))
               (replace slice (nreverse slice))))))
      (format t "~A~%Congratulations, you did it in ~D reversals!~%" numbers score))))
