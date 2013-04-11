(ql:quickload 'ironclad)
(defun md5 (sequence)
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :md5 sequence)))
