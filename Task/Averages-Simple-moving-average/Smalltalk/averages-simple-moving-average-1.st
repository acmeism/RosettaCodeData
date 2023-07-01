Object subclass: MovingAverage [
    |valueCollection period collectedNumber sum|
    MovingAverage class >> newWithPeriod: thePeriod [
	|r|
	r := super basicNew.
	^ r initWithPeriod: thePeriod
    ]
    initWithPeriod: thePeriod [
    	valueCollection := OrderedCollection new: thePeriod.
	period := thePeriod.
	collectedNumber := 0.
	sum := 0
    ]
    sma [   collectedNumber < period
            ifTrue: [ ^ sum / collectedNumber ]
            ifFalse: [ ^ sum / period ] ]
    add: value [
        collectedNumber < period
   	ifTrue: [
	   sum := sum + value.
	   valueCollection add: value.
	   collectedNumber := collectedNumber + 1.
	]
	ifFalse: [
	   sum := sum - (valueCollection removeFirst).
	   sum := sum + value.
	   valueCollection add: value
	].
	^ self sma
    ]
].
