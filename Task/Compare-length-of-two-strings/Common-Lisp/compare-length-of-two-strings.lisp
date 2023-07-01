(defun sort-and-print-strings (strings)
  (dolist (s (sort (copy-list strings) #'> :key #'length))
    (format t "~A ~A~%" (length s) s)))

(sort-and-print-strings '("Lisp" "stands" "for" "List" "Processing"))
