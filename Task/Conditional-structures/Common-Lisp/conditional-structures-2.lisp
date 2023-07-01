(cond ((= val 1)                 (print "no"))
      ((and (> val 3) (< val 6)) (print "yes"))
      ((> val 99)                (print "too far"))
      (T                         (print "no way, man!")))
