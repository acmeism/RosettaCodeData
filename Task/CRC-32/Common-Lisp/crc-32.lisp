(ql:quickload :ironclad)
(defun string-to-digest (str digest)
  "Return the specified digest for the ASCII string as a hex string."
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence digest
                              (ironclad:ascii-string-to-byte-array str))))

(string-to-digest "The quick brown fox jumps over the lazy dog" :crc32)
