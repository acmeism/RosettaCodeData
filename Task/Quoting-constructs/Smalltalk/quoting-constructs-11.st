in the True class:
ifTrue: aBlock
    ^ aBlock value "I am true, so I evaluate the block"

in the False class:
ifTrue: aBlock
    ^ nil  "I am false, so I ignore the block"
