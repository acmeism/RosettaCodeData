(ql:quickload 'ironclad)
(defun md5 (str)
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :md5
                              (ironclad:ascii-string-to-byte-array str))))
(defvar *tests* '(""
                  "a"
                  "abc"
                  "message digest"
                  "abcdefghijklmnopqrstuvwxyz"
                  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
                  "12345678901234567890123456789012345678901234567890123456789012345678901234567890"))
(dolist (msg *tests*)
  (format T "~s: ~a~%" msg (md5 msg)))
