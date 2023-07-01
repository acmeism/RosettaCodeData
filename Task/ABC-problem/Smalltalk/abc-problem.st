ABCPuzzle>>test
	#('A' 'BARK' 'BOOK' 'TreaT' 'COMMON' 'sQUAD' 'CONFuSE') do: [ :each |
		Transcript crShow: each, ': ', (self solveFor: each) asString ]

ABCPuzzle>>solveFor: letters
	| blocks |
	blocks := #('BO' 'XK' 'DQ' 'CP' 'NA' 'GT' 'RE' 'TG' 'QD' 'FS' 'JW' 'HU' 'VI' 'AN' 'OB' 'ER' 'FS' 'LY' 'PC' 'ZM').
	^ self solveFor: letters asUppercase with: blocks asOrderedCollection

ABCPuzzle>>solveFor: letters with: blocks
	| l ldash matches |
	letters isEmpty ifTrue: [ ^ true ].
	l := letters first.
	ldash := letters allButFirst.
	matches := blocks select: [  :b | b includes: l ].
	matches isEmpty ifTrue: [ ^ false ].
	matches do: [  :m | | bdash |
		bdash := blocks copy.
		bdash remove: m.
		(self solveFor: ldash with: bdash) ifTrue: [ ^ true ] ].
	^ false
