(defun longest-common-subsequence (array1 array2)
  (let* ((l1 (length array1))
         (l2 (length array2))
         (results (make-array (list l1 l2) :initial-element nil)))
    (declare (dynamic-extent results))
    (labels ((lcs (start1 start2)
               ;; if either sequence is empty, return (() 0)
               (if (or (eql start1 l1) (eql start2 l2)) (list '() 0)
                 ;; otherwise, return any memoized value
                 (let ((result (aref results start1 start2)))
                   (if (not (null result)) result
                     ;; otherwise, compute and store a value
                     (setf (aref results start1 start2)
                           (if (eql (aref array1 start1) (aref array2 start2))
                             ;; if they start with the same element,
                             ;; move forward in both sequences
                             (destructuring-bind (seq len)
                                 (lcs (1+ start1) (1+ start2))
                               (list (cons (aref array1 start1) seq) (1+ len)))
                             ;; otherwise, move ahead in each separately,
                             ;; and return the better result.
                             (let ((a (lcs (1+ start1) start2))
                                   (b (lcs start1 (1+ start2))))
                               (if (> (second a) (second b))
                                 a
                                 b)))))))))
      (destructuring-bind (seq len) (lcs 0 0)
        (values (coerce seq (type-of array1)) len)))))
