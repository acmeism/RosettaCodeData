Number extend [
  factorial [
    self < 0 ifTrue: [ self error: 'factorial is defined for natural numbers' ].
    self isZero ifTrue: [ ^1 ].
    ^self * ((self - 1) factorial)
  ]
].
