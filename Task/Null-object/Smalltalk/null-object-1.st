object isNil ifTrue: [ "true block" ]
             ifFalse: [ "false block" ].
nil isNil ifTrue: [ 'true!' displayNl ]. "output: true!"
foo isNil ifTrue: [ 'ouch' displayNl ].
x := (foo == nil).
x := foo isNil
