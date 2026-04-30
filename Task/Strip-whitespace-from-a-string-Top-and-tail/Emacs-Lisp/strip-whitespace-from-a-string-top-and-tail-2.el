(defun string-trim-left (str)
  (replace-regexp-in-string "^[ \t\r\n]*" "" str))

(defun string-trim-right (str)
  (replace-regexp-in-string "[ \t\r\n]*$" "" str))

(defun string-trim (str)
  (string-trim-left (string-trim-right str)))
