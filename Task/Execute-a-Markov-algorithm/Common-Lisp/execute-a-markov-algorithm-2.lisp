(defparameter
    *rules1*
"# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule")

;;; Lots of other defparameters for rules omitted here...

(defun test ()
  (format t "~A~%" (interpret (make-markov *rules1*) "I bought a B of As from T S."))
  (format t "~A~%" (interpret (make-markov *rules2*) "I bought a B of As from T S."))
  (format t "~A~%" (interpret (make-markov *rules3*) "I bought a B of As W my Bgage from T S."))
  (format t "~A~%" (interpret (make-markov *rules4*) "_1111*11111_"))
  (format t "~A~%" (interpret (make-markov *rules5*) "000000A000000"))
  )
(test)
I bought a bag of apples from my brother.
I bought a bag of apples from T shop.
I bought a bag of apples with my money from T shop.
11111111111111111111
00011H1111000
NIL
