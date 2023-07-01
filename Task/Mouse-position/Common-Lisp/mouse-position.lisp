(ql:quickload "ltk")
(in-package :ltk-user)
(defun motion (event)
    (format t "~a x position is ~a~&" event (event-x event)))

(with-ltk ()
    ;; create a small window. Enter the mouse to see lots of events.
    (bind *tk* "<Motion>" #'motion))
