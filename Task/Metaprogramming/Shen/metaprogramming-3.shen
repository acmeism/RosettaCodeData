(2-) (tc +)
true

(3+) (+ 1 2 3)
6 : number

(4+) +
+ : (number --> (number --> number))

(5-) (tc -)
false

(6-) (macroexpand [+ 1 2 3])
[+ 1 [+ 2 3]]
