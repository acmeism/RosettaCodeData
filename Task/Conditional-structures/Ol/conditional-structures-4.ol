(if (= (* 2 2) 4)
   (print "if-then-else*: equal")
else
   (print "if-then-else*: ..just do something..")
   (print "if-then-else*: non equal"))
; ==> if-then-else*: equal

(if (= (* 2 2) 4)
then
   (print "if-then-else*: ..just do something..")
   (print "if-then-else*: equal")
else
   (print "if-then-else*: ..just do something..")
   (print "if-then-else*: non equal"))
; ==> if-then-else*: ..just do something..
; ==> if-then-else*: equal

(if (= (* 2 2) 4) ; same as `when`
then
   (print "if-then-else*: ..just do something..")
   (print "if-then-else*: equal"))
; ==> if-then-else*: ..just do something..
; ==> if-then-else*: equal
