Object subclass: SEDOL [
  |weight charList|

  initialize [
    weight := Array from: { 1. 3. 1. 7. 3. 9 }.
    charList :=
      ('ABCDEFGHIJKLMNOPQRSTUVWXYZ' asOrderedCollection)
      collect: [ :c | ('AEIOU' includes: c) ifTrue: [ nil ] ifFalse: [ c ] ].
  ]

  SEDOL class >> new [
     ^ (self basicNew) initialize
  ]

  "to be considered private"
  blindCheckDigit: aSEDOL [ |sum|
     sum := 0.
     aSEDOL keysAndValuesDo: [ :i :c |
        ('0123456789' includes: c)
          ifTrue: [  sum := sum +
                            ((weight at: i) *
                            (Number readFrom: (c asString readStream))).
                  ]
          ifFalse: [ sum := sum + (((charList indexOf: c) + 9) *
                            (weight at: i))
                   ]
     ].
     ^ ((10 - (sum rem: 10)) rem: 10) displayString
  ]

  checked: aSEDOL [
     (aSEDOL size < 6) |
     (aSEDOL size > 7) |
     (aSEDOL asUppercase includesAnyOf: 'AEIOU' asSet )
     ifTrue: [ SystemExceptions.InvalidArgument
                 signalOn: aSEDOL
                 reason: 'Not a valid SEDOL'
             ]
     ifFalse: [ |t| t := aSEDOL copyFrom: 1 to: 6.
                ^ t , (self blindCheckDigit: t)
              ]
  ]
].
