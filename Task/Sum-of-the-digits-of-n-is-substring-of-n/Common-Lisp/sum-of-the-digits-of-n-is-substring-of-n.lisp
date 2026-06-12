(loop for n below 1000
      for s = (princ-to-string n)
      for sum = (loop for d across s sum (digit-char-p d))
      when (search (princ-to-string sum) s)
        collect n)
