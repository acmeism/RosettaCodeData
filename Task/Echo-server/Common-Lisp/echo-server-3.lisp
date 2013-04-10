(defactor tcp-naive-client (sock) (message)
  (format (socket-stream sock) message)
  (force-output (socket-stream sock))
  next)

(defparameter *client* (tcp-naive-client :sock (socket-connect "127.0.0.1" +port+)))

(send *client* "test~%test")
;; should print
;;   test
;;   test

(send *client* "test")
;; should print
;;   test

(defparameter *client2* (tcp-naive-client :sock (socket-connect "127.0.0.1" +port+)))

(send *client2* "woo!")
;; should print
;;   woo!
;; despite the fact that *client* isn't reading anything, and didn't terminate its last message with a newline
