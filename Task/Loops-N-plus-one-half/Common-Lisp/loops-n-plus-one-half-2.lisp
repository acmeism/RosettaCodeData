(loop for i from 1 upto 10 do
  (princ i)
  (if (= i 10) (return))
  (princ ", "))
