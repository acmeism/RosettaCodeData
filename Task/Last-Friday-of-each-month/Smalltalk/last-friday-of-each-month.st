Pharo Smalltalk

[ :yr | | firstDay firstFriday |
  firstDay := Date year: yr month: 1 day: 1.
  firstFriday := firstDay addDays: (6 - firstDay dayOfWeek).
  (0 to: 53)
    collect: [ :each | firstFriday addDays: (each * 7) ]
    thenSelect: [ :each |
      (((Date daysInMonth: each monthIndex forYear: yr) - each dayOfMonth) <= 6) and: [	each year = yr ] ] ]
