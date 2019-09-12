(tuple-case (tuple 'selector 1 2 3)
   ((case1 x y)
      (print "tuple-case: case1 " x ", " y))
   ((selector x y z)
      (print "tuple-case: selector " x ", " y ", " z))
   (else
      (print "tuple-case: i don't know")))
; ==> tuple-case: selector 1, 2, 3
