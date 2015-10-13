(defun trim-r (str)
  (replace-regexp-in-string " +$"  "" str) )

(setq str "    left between right  ")
(insert (trim-r str) )
