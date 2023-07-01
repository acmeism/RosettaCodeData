 balance > 0
     ifTrue: [Transcript cr; show: 'still sitting pretty!'.]
     ifFalse: [Transcript cr; show: 'No money till payday!'.].

 balance < 10 ifTrue:[ self goGetSomeMoney ].

 balance > 1000 ifTrue:[ self beHappy ].

 (balance < 10)
    ifFalse:[ self gotoHappyHour ]
    ifTrue:[ self noDrinksToday ].
