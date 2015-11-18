(defun trim (str)
  (mapconcat 'identity (split-string str)  " ") )

(setq str "    left between right  ")
(insert (trim str) )
