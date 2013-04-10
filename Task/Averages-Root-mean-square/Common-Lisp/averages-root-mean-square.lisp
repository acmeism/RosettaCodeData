(loop for x from 1 to 10
      for xx = (* x x)
      for n from 1
      summing xx into xx-sum
      finally (return (sqrt (/ xx-sum n)))))
