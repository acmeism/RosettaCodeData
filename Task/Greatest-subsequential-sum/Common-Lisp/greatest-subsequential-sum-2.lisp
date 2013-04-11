(defun max-subseq (seq)
  (loop for subsequence in (mapcon (lambda (x) (maplist #'reverse (reverse x))) seq)
        for sum = (reduce #'+ subsequence :initial-value 0)
        with max-subsequence
        maximizing sum into max
        if (= sum max) do (setf max-subsequence subsequence)
        finally (return max-subsequence))))
