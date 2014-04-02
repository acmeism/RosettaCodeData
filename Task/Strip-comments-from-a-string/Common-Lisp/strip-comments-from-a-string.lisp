(defun strip-comments (s cs)
  "Truncate s at the first occurrence of a character in cs."
  (defun comment-char-p (c)
    (some #'(lambda (x) (char= x c)) cs))
  (let ((pos (position-if #'comment-char-p s)))
    (subseq s 0 pos)))
