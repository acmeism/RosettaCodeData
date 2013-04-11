Object subclass: SDAccum [
    |sum sum2 num|
    SDAccum class >> new [  |o|
        o := super basicNew.
        ^ o init.
    ]
    init [ sum := 0. sum2 := 0. num := 0 ]
    value: aValue [
      sum := sum + aValue.
      sum2 := sum2 + ( aValue * aValue ).
      num := num + 1.
      ^ self stddev
    ]
    count [ ^ num ]
    mean [ num>0 ifTrue: [^ sum / num] ifFalse: [ ^ 0.0 ] ]
    variance [ |m| m := self mean.
               num>0 ifTrue: [^ (sum2/num) - (m*m) ] ifFalse: [ ^ 0.0 ]
             ]
    stddev [ ^ (self variance) sqrt ]
].
