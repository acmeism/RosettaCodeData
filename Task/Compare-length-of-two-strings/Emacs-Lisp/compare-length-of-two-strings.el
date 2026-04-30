(defun sort-list-by-string-length (list-of-strings)
  "Order LIST-OF-STRINGS from longest to shortest."
    (sort list-of-strings 'longer-string))  ; sort by "longer-string" function below

(defun longer-string (string-1 string-2)
  "Test if STRING-1 is longer than STRING-2."
  (> (length string-1) (length string-2)))  ; is STRING-1 longer than STRING-2?
