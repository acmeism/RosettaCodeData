(defun reverse-sep (words sep)
  (mapconcat 'identity (reverse (split-string words sep) ) sep) )

(defun reverse-chars (line)
  (reverse-sep line "") )

(defun reverse-words (line)
  (reverse-sep line " ") )

(progn
  (setq line "rosetta code phrase reversal")

  (insert (format "%s\n" (reverse-chars line) ))

    (insert (format "%s\n"
        (mapconcat 'identity (mapcar #'reverse-chars
                                     (split-string line) ) " ") ))

    (insert (format "%s\n" (reverse-words line) )))
