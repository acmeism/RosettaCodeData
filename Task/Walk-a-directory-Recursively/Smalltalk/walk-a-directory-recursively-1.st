Directory extend [
  wholeContent: aPattern do: twoBlock [
    self wholeContent: aPattern withLevel: 0 do: twoBlock.
  ]
  wholeContent: aPattern withLevel: l do: twoBlock [
    |cont|
    cont := (self contents) asSortedCollection.
    cont remove: '.'; remove: '..'.
    cont
    do: [ :n | |fn ps|
      ps := (Directory pathSeparator) asString.
      fn := (self name), ps, n.
      ((File name: fn) isDirectory)
      ifTrue: [
        twoBlock value: (n, ps) value: l.
	(Directory name: fn) wholeContent: aPattern withLevel: (l+1) do: twoBlock.
      ]
      ifFalse: [
        ( n =~ aPattern )
        ifMatched: [ :m |
          twoBlock value: n value: l
        ]
      ]
    ]
  ]
].
