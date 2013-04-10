Number extend [
  double [ ^ self * 2 ]
  halve  [ ^ self // 2 ]
  ethiopianMultiplyBy: aNumber withTutor: tutor [
    |result multiplier multiplicand|
    multiplier := self.
    multiplicand := aNumber.
    tutor ifTrue: [ ('ethiopian multiplication of %1 and %2' %
                      { multiplier. multiplicand }) displayNl ].
    result := 0.
    [ multiplier >= 1 ]
      whileTrue: [
        multiplier even ifFalse: [
                           result := result + multiplicand.
                           tutor ifTrue: [
                              ('%1, %2 kept' % { multiplier. multiplicand })
                                displayNl
                           ]
                        ]
                        ifTrue: [
                           tutor ifTrue: [
                             ('%1, %2 struck' % { multiplier. multiplicand })
			       displayNl
                           ]
                        ].
        multiplier := multiplier halve.
        multiplicand := multiplicand double.
      ].
    ^result
  ]
  ethiopianMultiplyBy: aNumber [ ^ self ethiopianMultiplyBy: aNumber withTutor: false ]
].
