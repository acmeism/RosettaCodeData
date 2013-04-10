OrderedCollection extend [
    median [
      self size = 0
        ifFalse: [ |s l|
          l := self size.
          s := self asSortedCollection.
	  (l rem: 2) = 0
	    ifTrue: [ ^ ((s at: (l//2 + 1)) + (s at: (l//2))) / 2 ]
	    ifFalse: [ ^ s at: (l//2 + 1) ]
	]
	ifTrue: [ ^nil ]
    ]
].
