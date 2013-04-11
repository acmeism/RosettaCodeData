; normal
(if (= 1 1)
  (print "Math works."))

; inverted
(->> (print "Math still works.")
     (if (= 1 1)))

; a la Haskell
(->> (print a " is " b)
     (let [a 'homoiconicity
           b 'awesome]))
