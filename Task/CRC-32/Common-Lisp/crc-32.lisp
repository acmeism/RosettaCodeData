(ql:quickload :ironclad)


(defun write-seq-base-16 (seq &key ((:stream *standard-output*)
                                    *standard-output*)
                              &aux (*print-base* 16))
  (map nil #'write seq))


(write-seq-base-16
 (crypto:digest-sequence 'ironclad:crc32
                         (crypto:ascii-string-to-byte-array
                          "The quick brown fox jumps over the lazy dog")))
