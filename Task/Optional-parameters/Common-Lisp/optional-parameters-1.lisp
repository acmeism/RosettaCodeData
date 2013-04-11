(defun sort-table (table &key (ordering #'string<)
                              (column 0)
                              reverse)
  (sort table (if reverse
                  (complement ordering)
                  ordering)
              :key (lambda (row) (elt row column))))
