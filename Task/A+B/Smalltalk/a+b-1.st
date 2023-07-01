'From Squeak3.7 of ''4 September 2004'' [latest update: #5989] on 8 August 2011 at 3:50:55 pm'!
Object subclass: #ABTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'rosettacode'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ABTask class
	instanceVariableNames: ''!

!ABTask class methodsFor: 'demo'!
parseInteger: inputStream
	^ Integer readFrom: inputStream skipSeparators! !

!ABTask class methodsFor: 'demo'!
sum: inputStream
	^ (self parseInteger: inputStream)
		+ (self parseInteger: inputStream)! !

!ABTask class methodsFor: 'demo'!
test2Plus2
	^ self
		sum: (ReadStream on: '2 2')! !

!ABTask class methodsFor: 'demo'!
test3Plus2
	^ self
		sum: (ReadStream on: '3 2')! !
