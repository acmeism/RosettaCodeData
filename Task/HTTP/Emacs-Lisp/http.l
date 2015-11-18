(with-current-buffer
    (url-retrieve-synchronously "http://www.rosettacode.org")
  (goto-char (point-min))
  (search-forward "\n\n" nil t)  ;; skip headers
  (prin1 (buffer-substring (point) (point-max)))
  (kill-buffer (current-buffer)))
