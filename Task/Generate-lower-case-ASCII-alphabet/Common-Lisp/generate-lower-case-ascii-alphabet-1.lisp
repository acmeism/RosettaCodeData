(defvar *lower*
  (loop with a = (char-code #\a)
        for i below 26
        collect (code-char (+ a i))))
