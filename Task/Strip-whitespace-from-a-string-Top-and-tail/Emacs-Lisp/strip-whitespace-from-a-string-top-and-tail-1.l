(defun trim-l (str)
  (replace-regexp-in-string "^ +"  "" str) )

(setq str "    left between right  ")
(insert (trim-l str) )
