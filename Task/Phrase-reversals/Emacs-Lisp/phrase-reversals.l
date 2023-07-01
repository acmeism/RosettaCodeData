(defun reverse-sep (words sep)
  (mapconcat 'identity (reverse (split-string words sep)) sep))

(defun reverse-chars (line)
  (reverse-sep line ""))

(defun reverse-words (line)
  (reverse-sep line " "))

(defvar line "rosetta code phrase reversal")

(with-output-to-temp-buffer "*reversals*"
  (princ (reverse-chars line))
  (terpri)
  (princ (mapconcat 'identity (mapcar #'reverse-chars
                                      (split-string line)) " "))
  (terpri)
  (princ (reverse-words line))
  (terpri))
