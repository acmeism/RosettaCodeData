(defun rosetta-code-hash-from-two-arrays (vector-1 vector-2 &key (test 'eql))
  (loop initially (assert (= (length vector-1) (length vector-2)))
        with table = (make-hash-table :test test :size (length vector-1))
        for k across vector-1
        for v across vector-2
        do (setf (gethash k table) v)
        finally (return table)))
