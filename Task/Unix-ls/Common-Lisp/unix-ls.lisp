(defun files-list (&optional (path "."))
  (let* ((dir (concatenate 'string path "/"))
         (abs-path (car (directory dir)))
         (file-pattern (concatenate 'string dir "*"))
         (subdir-pattern (concatenate 'string file-pattern "/")))
    (remove-duplicates
       (mapcar (lambda (p) (enough-namestring p abs-path))
               (mapcan #'directory (list file-pattern subdir-pattern)))
       :test #'string-equal)))

(defun ls (&optional (path "."))
  (format t "~{~a~%~}" (sort (files-list path) #'string-lessp)))
