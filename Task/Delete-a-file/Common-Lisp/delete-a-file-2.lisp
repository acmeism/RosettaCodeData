(let ((path (make-pathname :directory '(:relative "docs"))))
  (ext:delete-dir path))

(let ((path (make-pathname :directory '(:absolute "docs"))))
  (ext:delete-dir path))
