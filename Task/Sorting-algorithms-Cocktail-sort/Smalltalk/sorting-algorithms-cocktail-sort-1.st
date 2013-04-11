OrderedCollection extend [
  swap: indexA and: indexB [
    |t|
    t := self at: indexA.
    self at: indexA put: (self at: indexB).
    self at: indexB put: t
  ]
  cocktailSort [
    |swapped|
    [
      swapped := false.
      1 to: (self size - 1) do: [ :i |
        (self at: i) > (self at: (i+1)) ifTrue: [
          self swap: i and: (i+1).
	  swapped := true
        ]
      ].
      swapped ifFalse: [ ^ self ].
      swapped := false.
      (self size - 1) to: 1 by: -1 do: [ :i |
        (self at: i) > (self at: (i+1)) ifTrue: [
          self swap: i and: (i+1).
	  swapped := true
        ]
      ].
      swapped
    ] whileTrue: [ ].
    ^ self
  ]
].
