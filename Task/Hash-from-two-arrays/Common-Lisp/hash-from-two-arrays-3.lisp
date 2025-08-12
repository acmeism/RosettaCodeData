(let ((table (rosetta-code-hash-from-two-arrays #(foo bar baz) #(123 456 789))))
  (loop for key being the hash-keys of table do
    (format t "~a => ~a~%" key (gethash key table))))
