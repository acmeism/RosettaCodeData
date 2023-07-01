String compile:
  'lookAndSay |anElement nextElement counter coll newColl|
     coll := (self asOrderedCollection).
     newColl := OrderedCollection new.
     counter := 0.
     anElement := (coll first).
     [ coll size > 0 ]
     whileTrue: [
        nextElement := coll removeFirst.
	( anElement == nextElement ) ifTrue: [
           counter := counter + 1.
        ] ifFalse: [
	  newColl add: (counter displayString).
	  newColl add: (anElement asString).
	  anElement := nextElement.
	  counter := 1.
        ]
     ].
     newColl add: (counter displayString).
     newColl add: (anElement asString).
     ^('''' join: newColl)'
  classified: 'toys'.

result := OrderedCollection new.
r := '1'.
result add: r.
result addAll: ((1 to: 10) collect: [ :i |
  r := r lookAndSay.
]).
result.
