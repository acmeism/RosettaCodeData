Number extend [
  my_factorial [
    (self < 2) ifTrue: [ ^1 ]
               ifFalse: [ |c|
                 c := OrderedCollection new.
                 2 to: self do: [ :i | c add: i ].
		 ^ (c fold: [ :a :b | a * b ] )
               ]
  ]
].

7 factorial printNl.
7 my_factorial printNl.
