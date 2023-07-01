(defun rot13 (string)
  (map 'string
       (lambda (char &aux (code (char-code char)))
         (if (alpha-char-p char)
             (if (> (- code (char-code (if (upper-case-p char)
                                           #\A #\a))) 12)
                 (code-char (- code 13))
                 (code-char (+ code 13)))
             char))
       string))

(rot13 "Moron") ; -> "Zbeba"
