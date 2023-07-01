(with-open-stream (s *standard-output*)
  (format T "stdout is~:[ not~;~] a terminal~%"
          (interactive-stream-p s)))
