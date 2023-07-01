;; Greedy wrap line

(defun greedy-wrap (str width)
  (setq str (concatenate 'string str " ")) ; add sentinel
  (do* ((len (length str))
        (lines nil)
        (begin-curr-line 0)
        (prev-space 0 pos-space)
        (pos-space (position #\Space str) (when (< (1+ prev-space) len) (position #\Space str :start (1+ prev-space)))) )
       ((null pos-space) (progn (push (subseq str begin-curr-line (1- len)) lines) (nreverse lines)) )
    (when (> (- pos-space begin-curr-line) width)
      (push (subseq str begin-curr-line prev-space) lines)
      (setq begin-curr-line (1+ prev-space)) )))
