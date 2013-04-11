(defun max-subseq (list)
  (let ((best-sum 0) (current-sum 0) (end 0))
    ;; determine the best sum, and the end of the max subsequence
    (do ((list list (rest list))
         (i 0 (1+ i)))
        ((endp list))
      (setf current-sum (max 0 (+ current-sum (first list))))
      (when (> current-sum best-sum)
        (setf end i
              best-sum current-sum)))
    ;; take the subsequence of list ending at end, and remove elements
    ;; from the beginning until the subsequence sums to best-sum.
    (let* ((sublist (subseq list 0 (1+ end)))
           (sum (reduce #'+ sublist)))
      (do ((start 0 (1+ start))
           (sublist sublist (rest sublist))
           (sum sum (- sum (first sublist))))
          ((or (endp sublist) (eql sum best-sum))
           (values best-sum sublist start (1+ end)))))))
