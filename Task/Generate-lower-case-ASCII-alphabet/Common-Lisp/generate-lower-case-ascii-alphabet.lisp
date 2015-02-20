(defvar *lower*
  (loop with a = (char-code #\a)
        for i upto 25
        collect (code-char (+ a i))))
