Object subclass: BidimensionalArray [
  |biArr|
  <comment: 'bidim array'>
].
BidimensionalArray class extend [
  new: biDim [ |r|
    r := super new.
    r init: biDim.
    ^ r
  ]
].
BidimensionalArray extend [
  init: biDim [
     biArr := Array new: (biDim at: 1).
     1 to: (biDim at: 1) do: [ :i |
       biArr at: i put: (Array new: (biDim at: 2))
     ].
     ^ self
  ]
  at: biDim [
     ^ (biArr at: (biDim at: 1)) at: (biDim at: 2)
  ]
  at: biDim put: val [
     ^ (biArr at: (biDim at: 1)) at: (biDim at: 2) put: val
  ]
].
