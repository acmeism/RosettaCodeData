(defun all-subsequences (list)
  (labels ((subsequences (tail &optional (acc '()) (result '()))
             "Return a list of the subsequence designators of the
              subsequences of tail. Each subsequence designator is a
              list of tails of tail, the subsequence being the first
              element of each tail."
             (if (endp tail)
               (list* (reverse acc) result)
               (subsequences (rest tail) (list* tail acc)
                             (append (subsequences (rest tail) acc) result))))
           (continuous-p (subsequence-d)
             "True if the designated subsequence is continuous."
             (loop for i in subsequence-d
                   for j on (first subsequence-d)
                   always (eq i j)))
           (designated-sequence (subsequence-d)
             "Destructively transforms a subsequence designator into
              the designated subsequence."
             (map-into subsequence-d 'first subsequence-d)))
    (let ((nc-subsequences (delete-if #'continuous-p (subsequences list))))
      (map-into nc-subsequences #'designated-sequence nc-subsequences))))
