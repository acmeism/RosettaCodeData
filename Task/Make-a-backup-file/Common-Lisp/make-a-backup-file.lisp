(defun parse-integer-quietly (&rest args)
  (ignore-errors (apply #'parse-integer args)))

(defun get-next-version (basename)
  (flet ((parse-version (pathname)
                        (or (parse-integer-quietly
                              (string-left-trim (file-namestring basename)
                                                (file-namestring pathname))
                              :start 1) 0)))
    (let* ((files (directory (format nil "~A,*" (namestring basename))))
           (max (reduce #'max files :key #'parse-version)))
      (merge-pathnames (format nil "~a,~d" (file-namestring basename) (1+ max))
                       basename))))

(defun save-with-backup (filename data)
  (let ((file (probe-file filename)))
    (rename-file file (get-next-version file))
    (with-open-file (out file :direction :output)
      (print data out))))
