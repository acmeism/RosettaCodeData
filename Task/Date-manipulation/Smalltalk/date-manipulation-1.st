DateTime extend [
  setYear: aNum [ year := aNum ]
].

Object subclass: DateTimeTZ [
  |dateAndTime timeZoneDST timeZoneName timeZoneVar|

  DateTimeTZ class >> new [ ^(super basicNew) ]

  DateTimeTZ class >> readFromWithMeridian: aStream andTimeZone: aDict [
    |me|
    me := self new.
    ^ me initWithMeridian: aStream andTimeZone: aDict
  ]

  initWithMeridian: aStream andTimeZone: aDict [ |s|
    dateAndTime := DateTime readFrom: aStream copy.
    s := aStream collection asString.
    s =~ '[pP][mM]'
      ifMatched: [ :m |
        dateAndTime := dateAndTime + (Duration days: 0 hours: 12 minutes: 0 seconds: 0)
      ].
    aDict keysAndValuesDo: [ :k :v |
      s =~ k
        ifMatched: [ :x |
          dateAndTime := dateAndTime setOffset: (v at: 1).
	  timeZoneDST := (v at: 2) setOffset: (v at: 1).
	  timeZoneVar := (v at: 3).
	  timeZoneDST setYear: (self year). "ignore the year"
          timeZoneName := k
        ]
    ].
    ^ self
  ]

  setYear: aNum [ dateAndTime setYear: aNum ]
  year [ ^ dateAndTime year ]

  timeZoneName [ ^timeZoneName ]

  + aDuration [ |n|
    n := dateAndTime + aDuration.
    (n > timeZoneDST) ifTrue: [ n := n + timeZoneVar ].
    ^ (self copy dateTime: n)
  ]

  dateTime [ ^dateAndTime ]
  dateTime: aDT [ dateAndTime := aDT ]

].
