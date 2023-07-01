(defun bubble-sort (sequence &optional (compare #'<))
  "sort a sequence (array or list) with an optional comparison function (cl:< is the default)"
  (loop with sorted = nil until sorted do
        (setf sorted t)
        (loop for a below (1- (length sequence)) do
              (unless (funcall compare (elt sequence a)
                                       (elt sequence (1+ a)))
                (rotatef (elt sequence a)
                         (elt sequence (1+ a)))
                (setf sorted nil)))))
