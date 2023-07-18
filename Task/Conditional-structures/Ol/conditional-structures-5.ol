(case (* 2 2)
   (3 ; exact number
      (print "case: 3"))
   (4 ; exact number
      (print "case: 4"))
   ((5 6 7) ; list of numbers
      (print "case: 5 or 6 or 7"))
   (else
      (print "case: i don't know")))
; ==> case: 4

; extended case with usable else
(case (* 2 2)
   (3 ; exact number
      (print "case: 3"))
   (else => (lambda (num)
      (print "case: real value is " num))))
; ==> case: real value is 4

(case (* 2 2)
   (3 ; exact number
      (print "case: 3"))
   (else is num
      (print "case: real value is " num)))
; ==> case: real value is 4

; extended case with vectors
(case ['selector 1 2 3]
   (['case1 x y]
      (print "case: case1 " x ", " y))
   (['selector x y z]
      (print "case: selector " x ", " y ", " z))
   (else
      (print "case: i don't know")))
; ==> case: selector 1, 2, 3
