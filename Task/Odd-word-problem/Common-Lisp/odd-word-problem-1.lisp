(defun odd-word (s)
  (let ((stream (make-string-input-stream s)))
    (loop for forwardp = t then (not forwardp)
          while (if forwardp
                    (forward stream)
                    (funcall (backward stream)))) ))

(defun forward (stream)
  (let ((ch (read-char stream)))
    (write-char ch)
    (if (alpha-char-p ch)
	(forward stream)
        (char/= ch #\.))))

(defun backward (stream)
  (let ((ch (read-char stream)))
    (if (alpha-char-p ch)
        (prog1 (backward stream) (write-char ch))
        #'(lambda () (write-char ch) (char/= ch #\.)))) )
