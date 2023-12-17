(defun first-index (word words (i . 0))
  (loop
    (until (null words)
      (error word '! is! missing))
    (until (eq word (car words))
      i)
    (setq words (cdr words))
    (setq i (add1 i))))

(defun last-index (word words (i . 0) (last-i . nil))
  (loop
    (until (null words)
      (cond (last-i) (t (error word '! is! missing))))
    (cond ((eq word (car words))
           (setq last-i i)))
    (setq words (cdr words))
    (setq i (add1 i))))
