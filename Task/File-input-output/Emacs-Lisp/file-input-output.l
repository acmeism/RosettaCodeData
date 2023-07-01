(defvar input (with-temp-buffer
                (insert-file-contents "input.txt")
                (buffer-string)))

(with-temp-file "output.txt"
  (insert input))
