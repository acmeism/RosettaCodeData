(progn
  (setq string "top and tail")
  (insert (format "%s\n" string) )
  (setq len (length string) )
  (insert (format "%s\n" (substring string 1) ))
  (insert (format "%s\n" (substring string 0 (1- len) )))
  (insert (format "%s\n" (substring string 1 (1- len) ))))
