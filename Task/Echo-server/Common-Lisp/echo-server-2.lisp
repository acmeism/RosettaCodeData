(defun echo-send (message port)
  (with-client-socket (sock str "127.0.0.1" port)
    (write-string message str)
    (force-output str)
    (when (wait-for-input sock :timeout 5)
      (coerce (read-all str) 'string))))

(echo-send "Hello echo!" 12321)
