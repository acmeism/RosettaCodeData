(maphash (lambda (key value)
           (format t "~&Key: ~a, Value: ~a." key value))
         hash-table)
