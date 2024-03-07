(defun stripchars (s chars)
  (seq-into
   (seq-filter (lambda (x) (not (seq-contains chars x))) s)
   'string))

(stripchars "She was a soul stripper. She took my heart!" "aei")
