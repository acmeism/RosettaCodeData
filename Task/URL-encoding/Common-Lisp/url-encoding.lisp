(defun needs-encoding-p (char)
  (not (digit-char-p char 36)))

(defun encode-char (char)
  (format nil "%~2,'0X" (char-code char)))

(defun url-encode (url)
  (apply #'concatenate 'string
         (map 'list (lambda (char)
                      (if (needs-encoding-p char)
                          (encode-char char)
                          (string char)))
              url)))

(url-encode "http://foo bar/")
