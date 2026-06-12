(defun print-words-containing-substring (str len path)
  (with-open-file (s path :direction :input)
    (do ((line (read-line s nil :eof) (read-line s nil :eof)))
        ((eql line :eof)) (when (and (> (length line) len)
                                     (search str line))
                            (format t "~a~%" line)))))

(print-words-containing-substring "the" 11 "unixdict.txt")
