CommandLineHandler subclass: #ChatHistorySearchCommandLineHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RosettaCode'!

!ChatHistorySearchCommandLineHandler methodsFor: 'activation' stamp: 'EduardoPadoan 1/27/2019 15:18'!
activate
	self searchHistoryFor: self arguments first.
	self quit! !


!ChatHistorySearchCommandLineHandler methodsFor: 'commands' stamp: 'EduardoPadoan 1/27/2019 17:01'!
searchHistoryFor: aString
	| today startDate |
	
	"XXX Doesn't account for DST"
	today := DateAndTime now offset: 1 hours.
	startDate := today - 10 days.

	startDate to: today by: 1 days do: [ :targetDate |
		| url response |

		url := String streamContents: [ :aStream |
			aStream nextPutAll: 'http://tclers.tk/conferences/tcl/'.
			targetDate printYMDOn: aStream.
			aStream nextPutAll: '.tcl'.
		].

		response := ZnEasy get: url.

		response contents asString linesDo: [ :line |
			(line asLowercase includesSubstring: aString asLowercase) ifTrue: [
				self stdout print: line; lf.
			]
		]
	]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ChatHistorySearchCommandLineHandler class
	instanceVariableNames: ''!

!ChatHistorySearchCommandLineHandler class methodsFor: 'accessing' stamp: 'EduardoPadoan 1/27/2019 14:53'!
description
	^ 'Look for a pattern in the TCL chat history'! !

!ChatHistorySearchCommandLineHandler class methodsFor: 'accessing' stamp: 'EduardoPadoan 1/27/2019 14:50'!
commandName
	^ 'searchHistory'! !
