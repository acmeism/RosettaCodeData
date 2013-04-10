;; iterate using dolist, destructure manually
(dolist (pair alist)
  (destructuring-bind (key . value) pair
    (format t "~&Key: ~a, Value: ~a." key value)))

;; iterate and destructure with loop
(loop for (key . value) in alist
      do (format t "~&Key: ~a, Value: ~a." key value))
