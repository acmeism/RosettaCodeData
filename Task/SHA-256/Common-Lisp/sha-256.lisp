(ql:quickload 'ironclad)
(defun sha-256 (str)
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :sha256
                              (ironclad:ascii-string-to-byte-array str))))

(sha-256 "Rosetta code")
