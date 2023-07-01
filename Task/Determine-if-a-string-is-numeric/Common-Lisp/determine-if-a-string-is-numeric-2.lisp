(defun numeric-string-p (string)
      (ignore-errors (parse-number:parse-number string)))  ; parse failed, return false (nil)
