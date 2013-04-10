"Conditionals in Smalltalk are really messages sent to Boolean objects"
 balance > 0
     ifTrue: [Transcript cr; show: 'still sitting pretty!'.]
     ifFalse: [Transcript cr; show: 'No money till payday!'.].
