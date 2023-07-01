(defun pangramp (s)
  (null (set-difference
          (loop for c from (char-code #\A) upto (char-code #\Z) collect (code-char c))
          (coerce (string-upcase s) 'list))))
