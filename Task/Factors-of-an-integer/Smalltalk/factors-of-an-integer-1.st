Integer>>factors
	| a |
	a := OrderedCollection new.
	1 to: (self / 2) do: [ :i |
		((self \\ i) = 0) ifTrue: [ a add: i ] ].
	a add: self.
	^a
