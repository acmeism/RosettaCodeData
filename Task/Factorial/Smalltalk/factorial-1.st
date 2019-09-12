Number extend [
  my_factorial [
    (self < 2)
        ifTrue: [ ^1 ]
        ifFalse: [
	    ^ (2 to: self) fold: [ :a :b | a * b ]
        ]
  ]
].

7 factorial printNl.
7 my_factorial printNl.
