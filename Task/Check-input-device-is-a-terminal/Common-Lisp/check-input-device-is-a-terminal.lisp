(with-open-stream (s *standard-input*)
  (format T "stdin is~:[ not~;~] a terminal~%"
          (interactive-stream-p s)))
