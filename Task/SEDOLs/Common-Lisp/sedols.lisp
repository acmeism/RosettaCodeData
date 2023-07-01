(defun append-sedol-check-digit (sedol &key (start 0) (end (+ start 6)))
  (assert (<= 0 start end (length sedol)))
  (assert (= (- end start) 6))
  (loop
       :with checksum = 0
       :for weight :in '(1 3 1 7 3 9)
       :for index :upfrom start
       :do (incf checksum (* weight (digit-char-p (char sedol index) 36)))
       :finally (let* ((posn (- 10 (mod checksum 10)))
		       (head (subseq sedol start end))
		       (tail (digit-char posn)))
		  (return (concatenate 'string head (list tail))))))
