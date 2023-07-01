String extend [
  palindro [                  "Non-recursive"
    ^ self = (self reverse)
  ]
  palindroR [                 "Recursive"
    (self size) <= 1 ifTrue: [ ^true ]
      ifFalse: [ |o i f| o := self asOrderedCollection.
          i := o removeFirst.
          f := o removeLast.
          i = f ifTrue: [ ^ (o asString) palindroR ]
                ifFalse: [ ^false ]
      ]
  ]
].
