Number extend [
  my_factorial [
    self < 0 ifTrue: [ self error: 'my_factorial is defined for natural numbers' ].
    self isZero ifTrue: [ ^1 ].
    ^self * ((self - 1) my_factorial)
  ]
].
