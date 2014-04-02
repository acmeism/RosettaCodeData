(ql:quickload 'ironclad)
(defun string-to-ripemd-160 (str)
  "Return the RIPEMD-160 digest of the given ASCII string."
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :ripemd-160
                              (ironclad:ascii-string-to-byte-array str)))

(string-to-ripemd-160 "Rosetta Code")
