(cond
   ((= (* 2 2) 4)
      (print "cond: equal"))
   ((= (* 2 2) 6)
      (print "cond: not equal"))
   (else
      (print "cond: i don't know")))
; ==> cond: equal
