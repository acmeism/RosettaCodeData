(ql:quickload 'ironclad)
(defun md4 (str)
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :md4
                              (ironclad:ascii-string-to-byte-array str))))

(md4 "Rosetta Code")
