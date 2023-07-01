(defun common-directory-path (&rest paths)
  (do* ((pathnames (mapcar #'(lambda (path) (cdr (pathname-directory (pathname path)))) paths)) ; convert strings to lists of subdirectories
     (rem pathnames (cdr rem))
     (pos (length (first rem))) ) ; position of first mismatched element
    ((null (cdr rem)) (make-pathname :directory (cons :absolute (subseq (first pathnames) 0 pos)))) ; take the common sublists and convert back to a pathname
  (setq pos (min pos (mismatch (first rem) (second rem) :test #'string-equal))) )) ; compare two paths
