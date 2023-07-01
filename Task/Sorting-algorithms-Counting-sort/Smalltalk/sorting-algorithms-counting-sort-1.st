OrderedCollection extend [
    countingSortWithMin: min andMax: max [
	|oc z|
	oc := OrderedCollection new.
	1 to: (max - min + 1) do: [ :n| oc add: 0 ].
	self do: [ :v |
	    oc at: (v - min + 1) put: ( (oc at: (v - min + 1)) + 1)
	].
	z := 1.
	min to: max do: [ :i |
	    1 to: (oc at: (i - min + 1)) do: [ :k |
		self at: z put: i.
		z := z + 1.
	    ]
	]
    ]
].
