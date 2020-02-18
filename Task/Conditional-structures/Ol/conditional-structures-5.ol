(case (vector 'selector 1 2 3)
   (['case1 x y]
      (print "case: case1 " x ", " y))
   (['selector x y z]
      (print "case: selector " x ", " y ", " z))
   (else
      (print "case: i don't know")))
; ==> tuple-case: selector 1, 2, 3
