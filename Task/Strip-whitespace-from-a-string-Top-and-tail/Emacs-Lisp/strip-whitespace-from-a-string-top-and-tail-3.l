(defun trim (str)
  (trim-l (trim-r str) ))

(setq str "    left between right  ")
(insert (trim str) )
