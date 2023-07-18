(when (= (* 2 2) 4)
   (print "when: ..just do something..")
   (print "when: equal"))
; ==> when: ..just do something..
; ==> when: equal

(unless (= (* 2 2) 6)
   (print "unless: ..just do something..")
   (print "unless: not equal"))
; ==> unless: ..just do something..
; ==> unless: not equal
