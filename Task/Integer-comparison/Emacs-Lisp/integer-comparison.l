(defun integer-comparison (a b)
  "Compare A to B and print the outcome in the message buffer."
  (interactive "nFirst integer ⇒\nnSecond integer ⇒")
  (cond
    ((< a b) (message "%d is less than %d." a b))
    ((> a b) (message "%d is greater than %d." a b))
    ((= a b) (message "%d is equal to %d." a b))))
