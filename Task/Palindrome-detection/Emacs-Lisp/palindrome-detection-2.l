(defun test-if-palindrome (text)
  (setq text (replace-regexp-in-string "[[:space:][:punct:]]" "" text))  ; remove spaces and punctuation, by replacing them with nothing
  (string-equal-ignore-case text (reverse text)))                        ; ignore case when looking at reversed text
