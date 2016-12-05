(ql:quickload :cl-fad)
(defun mapc-directory-tree (fn directory &key (depth-first-p t))
  (dolist (entry (cl-fad:list-directory directory))
    (unless depth-first-p
      (funcall fn entry))
    (when (cl-fad:directory-pathname-p entry)
      (mapc-directory-tree fn entry))
    (when depth-first-p
      (funcall fn entry))))
