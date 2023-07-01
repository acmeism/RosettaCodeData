(with-hash-table-iterator (next-entry hash-table)
  (loop
   (multiple-value-bind (nextp key value) (next-entry)
     (if (not nextp)
       (return)
       (format t "~&Key: ~a, Value: ~a." key value)))))
