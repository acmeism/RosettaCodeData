(do ((c (read-char) (read-char)))
    ((eof-object? c) 'done)
  (display c))
