(add-to-list 'load-path "./")
(load "./file1.el")
(insert (format "%d" (sum (number-sequence 1 100) )))
