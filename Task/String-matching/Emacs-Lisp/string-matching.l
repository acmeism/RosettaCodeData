(defun match (word str)
  (progn

    (setq regex (format "^%s.*$" word) )

    (if (string-match regex str)
	(insert (format "%s found in beginning of: %s\n" word str) )
      (insert (format "%s not found in beginning of: %s\n" word str) ))

    (setq pos (string-match word str) )

    (if pos
	(insert (format "%s found at position %d in: %s\n" word pos str) )
      (insert (format "%s not found in: %s\n" word str) ))

    (setq regex (format "^.*%s$" word) )

    (if (string-match regex str)
	(insert (format "%s found in end of: %s\n" word str) )
      (insert (format "%s not found in end of: %s\n" word str) ))))

(setq string "before center after")

(progn
  (match "center" string)
  (insert "\n")
  (match "before" string)
  (insert "\n")
  (match "after" string) )
