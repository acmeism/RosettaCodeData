(defun match (word str)
   (setq pos (string-match word str) )
  (if pos
      (progn
	(insert (format "%s found at position %d in: %s\n" word pos str) )
	(setq regex (format "^.+%s" word) )
	(setq str (replace-regexp-in-string regex (format "left %s" word) str) )
	(setq regex (format "%s.+$" word) )
	(setq str (replace-regexp-in-string regex (format "%s right" word) str) )
	(insert (format "result: %s\n"  str) ))
    (insert (format "%s not found in: %s\n" word str) )))

(setq str1 "before center after" str2 "before centre after")

(progn
  (match "center" str1)
  (insert "\n")
  (match "center" str2) )
