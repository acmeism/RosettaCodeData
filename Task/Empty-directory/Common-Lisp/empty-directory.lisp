(defun empty-directory-p (path)
  (and (null (directory (concatenate 'string path "/*")))
       (null (directory (concatenate 'string path "/*/")))))
