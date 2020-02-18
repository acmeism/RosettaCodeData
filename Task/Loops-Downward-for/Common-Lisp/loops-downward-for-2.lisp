(do ((n 10 (decf n)))			; Initialize to 0 and downward in every loop
    ((< n 0))				; Break condition when negative
  (print n))				; On every loop print value
