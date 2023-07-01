Object subclass: HappyNumber [
  |cache negativeCache|
  HappyNumber class >> new [ |me|
    me := super new.
    ^ me init
  ]
  init [ cache := Set new. negativeCache := Set new. ]

  hasSad: aNum [
    ^ (negativeCache includes: (self recycle: aNum))
  ]
  hasHappy: aNum [
    ^ (cache includes: (self recycle: aNum))
  ]
  addHappy: aNum [
    cache add: (self recycle: aNum)
  ]
  addSad: aNum [
    negativeCache add: (self recycle: aNum)
  ]

  recycle: aNum [ |r n| r := Bag new.
    n := aNum.
    [ n > 0 ]
    whileTrue: [ |d|
      d := n rem: 10.
      r add: d.
      n := n // 10.
    ].
    ^r
  ]

  isHappy: aNumber [ |cycle number newnumber|
    number := aNumber.
    cycle := Set new.
    [ (number ~= 1) & ( (cycle includes: number) not ) ]
    whileTrue: [
      (self hasHappy: number)
      ifTrue: [ ^true ]
      ifFalse: [
        (self hasSad: number) ifTrue: [ ^false ].
        cycle add: number.
        newnumber := 0.
        [ number > 0 ]
        whileTrue: [ |digit|
          digit := number rem: 10.
          newnumber := newnumber + (digit * digit).
 	  number := (number - digit) // 10.
        ].
        number := newnumber.
      ]
    ].
    (number = 1)
    ifTrue: [
      cycle do: [ :e | self addHappy: e ].
      ^true
    ]
    ifFalse: [
      cycle do: [ :e | self addSad: e ].
      ^false
    ]
  ]
].
