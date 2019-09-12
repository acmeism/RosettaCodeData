(case (* 2 2)
   (3
      (print "case: 3"))
   (4
      (print "case: 4"))
   ((5 6 7)
      (print "case: 5 or 6 or 7"))
   (else
      (print "case: i don't know")))
; ==> case: 4
