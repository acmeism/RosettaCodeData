(defun longest-ordered-words ()
  (find-longest-ordered-words
    (open 'notes/unixdict!.txt t)))

(defun find-longest-ordered-words
             (h (len . 0) (word) (words))
  (loop
    (until (eof h)
      (close h)
      words)
    (setq word (readline h))
    (cond ((lessp (chars word) len))
          ((not (ordered-p word)))
          ((eq (chars word) len)
           (setq words (cons word words)))
          (t
           (setq len (chars word))
           (setq words (list word))))))

(defun ordered-p (word)
  (nondecreasing-p
    (mapc ordinal (explode word))))

(defun nondecreasing-p (numbers)
  (or (null numbers)
      (null (cdr numbers))
      (and (not (greaterp (car numbers) (cadr numbers)))
           (nondecreasing-p (cdr numbers)))))
