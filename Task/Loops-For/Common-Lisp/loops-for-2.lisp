(dotimes (i 5)
  (dotimes (j (+ i 1))
    (write-char #\*))
  (terpri))
