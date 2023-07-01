(defun count-word (n pathname)
  (with-open-file (s pathname :direction :input)
    (loop for line = (read-line s nil nil) while line
          nconc (list-symb (drop-noise line)) into words
          finally (return (subseq (sort (pair words)
                                        #'> :key #'cdr)
                                  0 n)))))

  (defun list-symb (s)
    (let ((*read-eval* nil))
      (read-from-string (concatenate 'string "(" s ")"))))

(defun drop-noise (s)
  (delete-if-not #'(lambda (x) (or (alpha-char-p x)
                                   (equal x #\space)
                                   (equal x #\-))) s))

(defun pair (words &aux (hash (make-hash-table)) ac)
  (dolist (word words) (incf (gethash word hash 0)))
  (maphash #'(lambda (e n) (push `(,e . ,n) ac)) hash) ac)
