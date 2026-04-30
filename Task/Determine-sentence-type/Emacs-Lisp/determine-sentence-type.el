(defun get-last-character (str)
  "Return the last character of STR."
  (let ((str-length))
    (setq str-length (length str))
    (substring str (- str-length 1) str-length)))

(defun classify-sentence (str)
  "Classify the type of sentence based on final punctuation."
  (let ((last-character (get-last-character str)))
    (cond ((string= last-character ".") (format "S - %s" str))
          ((string= last-character "!") (format "E - %s" str))
          ((string= last-character "?") (format "Q - %s" str))
          (t (format "N - %s" str)))))

(defun classify-multiple-sentences (str)
  "Classify each sentence as Q, S, E, or N."
  ;; sentence boundary is defined as:
  ;;   a period (full stop), exclamation point/mark, or question mark
  ;;   followed by one space
  ;;   followed by a capital letter
  ;; while the above will work for this exercise, it won't
  ;; work in other situations. See the Perl code in this section
  ;; for cases that the above will not cover.
  (let ((regex-sentence-boundary "\\([.?!]\\) \\([[:upper:]]\\)"))
    ;; split the text into list of individual sentences
    (dolist (one-sentence (split-string (replace-regexp-in-string regex-sentence-boundary "\\1\n\\2"  str) "\n"))
      ;; classify each sentence
      (insert (format "\n%s" (classify-sentence one-sentence))))))
