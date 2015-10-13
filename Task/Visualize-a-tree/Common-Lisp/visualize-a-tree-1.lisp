(defun visualize (tree)
  (labels
      ((rprint (list)
         (mapc #'princ (reverse list)))
       (vis-h (tree branches)
         (let ((len (length tree)))
           (loop
              for item in tree
              for idx from 1 to len do
                (cond
                  ((listp item)
                   (rprint (cdr branches))
                   (princ "+---+")
                   (let ((next (cons "|   "
                                     (if (= idx len)
                                         (cons "    " (cdr branches))
                                         branches))))
                     (terpri)
                     (rprint (if (null item)
                                 (cdr next)
                                 next))
                     (terpri)
                     (vis-h item next)))
                  (t
                   (rprint (cdr branches))
                   (princ item)
                   (terpri)
                   (rprint (if (= idx len)
                               (cdr branches)
                               branches))
                   (terpri)))))))
    (vis-h tree '("|   "))))
