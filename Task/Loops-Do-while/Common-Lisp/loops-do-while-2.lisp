(loop with val = 0
      do (print (incf val))
      until (= 0 (mod val 6)))
