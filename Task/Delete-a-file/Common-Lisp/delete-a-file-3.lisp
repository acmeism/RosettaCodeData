(let ((path (make-pathname :directory '(:relative "docs"))))
  (cl-fad:delete-directory-and-files path))
