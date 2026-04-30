(defun find-maximum (items)
  (let (max)
    (dolist (item items)
      (when (or (not max) (> item max))
        (setq max item)))
    max))

(find-maximum '(2 7 5)) ;=> 7
