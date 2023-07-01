(defun simple-insert-after (new-element old-element list &key (test 'eql))
  (let ((tail (rest (member old-element list :test test))))
    (nconc (ldiff list tail)
           (cons new-element tail))))
