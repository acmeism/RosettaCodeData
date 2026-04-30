(let ((buffer (url-retrieve-synchronously "http://www.rosettacode.org")))
  (unwind-protect
      (with-current-buffer buffer
        (message "%s" (buffer-substring url-http-end-of-headers (point-max))))
    (kill-buffer buffer)))
