(defun prepare-text (str)
  "Prepare STR for word frequency work."
  (sort (split-string (downcase str) "[\s\f\t\n\r\v[:punct:]]+" :OMIT-NULLS) #'string<))

(defun get-unique-words (str)
  "Get a list of lowercase unique words in STR."
  (seq-uniq (prepare-text str)))

(defun count-word-frequency (buffer-name number-requested)
  "List top NUMBER-REQUESTED word frequencies in BUFFER-NAME."
  (let* ((str)
         (unique-words)
         (words-and-count (make-hash-table :test 'equal))
         (count-of-duplicates)
         (matches))
    (with-current-buffer buffer-name
      (setq str (buffer-string))
      (setq unique-words (get-unique-words str))
      (dolist (one-unique-word unique-words)
        (setq count-of-duplicates (count-matches (format "\\b%s\\b" one-unique-word) (point-min) (point-max)))
        (puthash one-unique-word count-of-duplicates words-and-count)))
    (maphash (lambda (key value)
               (push (cons key value) matches))
             words-and-count)
    (setq matches (sort matches (lambda (a b) (> (cdr a) (cdr b)))))
    (setq matches (seq-take matches number-requested))
    (dolist (match matches)
      (insert (format "\n%s	%s" (car match) (cdr match))))))
