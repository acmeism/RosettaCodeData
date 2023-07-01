Object subclass: AccumulatorFactory [
  AccumulatorFactory class >> new: aNumber [
    |r sum|
    sum := aNumber.
    r := [ :a |
           sum := sum +  a.
           sum
         ].
    ^r
  ]
]

|x y|
x := AccumulatorFactory new: 1.
x value: 5.
y := AccumulatorFactory new: 3.
(x value: 2.3) displayNl.
"x inspect."
"de-comment the previous line to show that x is a block closure"
