;; load cl-heredoc with QuickLisp
(ql:quickload 'cl-heredoc)

;; use #>xxx>yyyyyyyy!xxx as read-macro for heredoc
(set-dispatch-macro-character #\# #\> #'cl-heredoc:read-heredoc)

;; example:
(format t "~A~%" #>eof1>Write whatever (you) "want",
  no matter how many lines or what characters until
the magic end sequence has been reached!eof1)
