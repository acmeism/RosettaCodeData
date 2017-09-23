(defvar *lowercase-alphabet-string*
  (map 'string #'code-char (loop
			      for c from (char-code #\a) to (char-code #\z)
			      collect c))
  "The 26 lower case letters in alphabetical order.")
