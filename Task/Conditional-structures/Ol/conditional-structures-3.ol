(unless (= (* 2 2) 4) (print "unless: non equal"))
(unless (= (* 2 2) 6) (print "unless: i don't know"))
(unless (= (* 2 2) 4) (print "unless: non equal") (print "unless: equal"))
(unless (= (* 2 2) 6) (print "unless: i don't know") (print "unless: non equal"))
; ==> unless: i don't know
; ==> unless: equal
; ==> unless: i don't know
