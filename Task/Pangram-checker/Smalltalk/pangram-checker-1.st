!String methodsFor: 'testing'!
isPangram
	^((self collect: [:c | c asUppercase]) select: [:c | c >= $A and: [c <= $Z]]) asSet size = 26
