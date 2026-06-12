(defun read-words (filename)
  (let ((words '()))
    (with-open-file (s filename :direction :input)
      (loop
        (let ((word (read-line s nil nil)))
          (if word
              (when (> (length word) 6)
                (setq words (cons word words)))
            (return (reverse words))))))))

(defun anadromes ()
  (let ((words (read-words "notes/words.txt"))
        (dict (make-hash-table :test #'equalp)))
    (dolist (word words)
      (setf (gethash word dict) word))
    (mapcar
      (lambda (word)
        (list word (gethash (reverse word) dict)))
      (remove-if-not
        (lambda (word)
          (let ((rev (reverse word)))
            (and (string-lessp word rev)
                 (gethash rev dict))))
        words))))

(format t "~%~:{~10A ~10A~%~}~%"
        (anadromes))
