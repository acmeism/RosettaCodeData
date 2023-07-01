'From Pharo7.0.3 of 12 April 2019 [Build information: Pharo-7.0.3+build.158.sha.0903ade8a6c96633f07e0a7f1baa9a5d48cfdf55 (64 Bit)] on 30 October 2019 at 4:24:17.115807 pm'!
Object subclass: #GuessingGame
	instanceVariableNames: 'min max uiManager tries'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'GuessingGame'!

!GuessingGame methodsFor: 'initialization' stamp: 'EduardoPadoan 10/26/2019 23:51'!
initialize
	uiManager := UIManager default.
	tries := 0! !


!GuessingGame methodsFor: 'services' stamp: 'EduardoPadoan 10/26/2019 23:40'!
alert: aString
	uiManager alert: aString! !


!GuessingGame methodsFor: 'accessing' stamp: 'EduardoPadoan 10/26/2019 23:36'!
max
	^ max! !

!GuessingGame methodsFor: 'accessing' stamp: 'EduardoPadoan 10/26/2019 23:36'!
min
	^ min! !

!GuessingGame methodsFor: 'accessing' stamp: 'EduardoPadoan 10/26/2019 23:36'!
min: anObject
	min := anObject! !

!GuessingGame methodsFor: 'accessing' stamp: 'EduardoPadoan 10/26/2019 23:36'!
max: anObject
	max := anObject! !


!GuessingGame methodsFor: 'playing-main' stamp: 'EduardoPadoan 10/27/2019 00:18'!
play
	| toGuess |
	toGuess := self selectNumber.
	[ :break |
		| choice |
		[
			choice := self getGuessOrExitWith: break.
			choice
				ifNil: [ self alert: 'Invalid Input' ]
				ifNotNil: [
					self incrementTries.
					choice = toGuess
                   ifTrue: [ self congratulateForGuess: choice andExitWith: break ]
                   ifFalse: [ choice > toGuess ifTrue: [ self alert: 'Too high' ]
                                               ifFalse: [ self alert: 'Too low' ] ]
				]
		] repeat.
	] valueWithExit.! !


!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/26/2019 23:39'!
makeRequest: aString
	^ uiManager request: aString! !

!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/26/2019 23:48'!
getGuessOrExitWith: anExitBlock
	^ [(self makeRequest: 'Guess number a between , min,' and ', max, '.') asInteger]
     on: MessageNotUnderstood "nil"
     do: [
         self sayGoodbye.
         anExitBlock value ].! !

!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/26/2019 23:51'!
incrementTries
	tries := tries + 1! !

!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/27/2019 00:05'!
sayGoodbye
	self alert: 'Gave up? Sad.'.! !

!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/27/2019 00:15'!
congratulateForGuess: anInteger andExitWith: anExitBlock
	self alert: 'Correct!! The value was indeed ', anInteger asString, '. Took you only ', tries asString, ' tries.'.
	^ anExitBlock value! !

!GuessingGame methodsFor: 'as yet unclassified' stamp: 'EduardoPadoan 10/26/2019 23:35'!
selectNumber
	^ (min to: max) atRandom ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

GuessingGame class
	slots: {  }!

!GuessingGame class methodsFor: 'creating' stamp: 'EduardoPadoan 10/27/2019 00:15'!
playFrom: aMinNumber to: aMaxNumber
	self new
		min: aMinNumber;
		max: aMaxNumber;
		play! !
