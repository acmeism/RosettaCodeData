(loop for i from 1 to 10
      do (write i)
      if (zerop (mod i 5))
        do (terpri)
      else
        do (write-string ", "))

(loop for i from 1 to 10 do
  (block continue
    (write i)
    (when (zerop (mod i 5))
      (terpri)
      (return-from continue))
    (write-string ", ")))
