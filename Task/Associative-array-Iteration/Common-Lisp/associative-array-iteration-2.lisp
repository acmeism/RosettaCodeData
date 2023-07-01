(loop for (key value) on plist :by 'cddr
      do (format t "~&Key: ~a, Value: ~a." key value))
