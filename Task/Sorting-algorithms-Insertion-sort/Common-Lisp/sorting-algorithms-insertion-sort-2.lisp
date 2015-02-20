(defun insertion-sort (sequence &optional (predicate #'<))
  (if (cdr sequence)
      (insert (car sequence)                 ;; insert the current item into
              (insertion-sort (cdr sequence) ;; the already-sorted
                              predicate)     ;; remainder of the list
              predicate)
      sequence)) ; a list of one element is already sorted

(defun insert (item sequence predicate)
  (cond ((null sequence) (list item))
        ((funcall (complement predicate)      ;; if the first element of the list
                              (car sequence)  ;; isn't better than the item,
                              item)           ;; cons the item onto
         (cons item sequence))                ;; the front of the list
        (t (cons (car sequence) ;; otherwise cons the first element onto the front of
                 (insert item   ;; the list of the item sorted with the rest of the list
                         (cdr sequence)
                         predicate)))))
