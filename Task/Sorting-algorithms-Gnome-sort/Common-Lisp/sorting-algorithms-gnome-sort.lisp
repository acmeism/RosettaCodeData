(defun gnome-sort (array predicate &aux (length (length array)))
  (do ((position (min 1 length)))
      ((eql length position) array)
    (cond
     ((eql 0 position)
      (incf position))
     ((funcall predicate
               (aref array position)
               (aref array (1- position)))
      (rotatef (aref array position)
               (aref array (1- position)))
      (decf position))
     (t (incf position)))))
