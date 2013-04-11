(loop for i from 1 upto 5 do
  (loop for j from 1 upto i do
    (write-char #\*))
  (write-line ""))
