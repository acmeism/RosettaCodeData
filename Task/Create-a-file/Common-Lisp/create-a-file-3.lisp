(let ((paths (list (make-pathname :directory '(:relative "docs"))
                     (make-pathname :directory '(:absolute "docs")))))
  (mapcar #'ensure-directories-exist paths))
