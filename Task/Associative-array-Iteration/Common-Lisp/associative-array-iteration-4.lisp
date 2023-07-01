(loop for key being each hash-key of hash-table using (hash-value value)
      do (format t "~&Key: ~a, Value: ~a." key value))
