(defun wget-drakma-string (url &optional (out *standard-output*))
  "Grab the body as a string, and write it to out."
  (write-string (drakma:http-request url) out))

(defun wget-drakma-stream (url &optional (out *standard-output*))
  "Grab the body as a stream, and write it to out."
  (loop with body = (drakma:http-request url :want-stream t)
        for line = (read-line body nil nil)
        while line do (write-line line)
        finally (close body)))

;; Use
(wget-drakma-stream "https://sourceforge.net")
