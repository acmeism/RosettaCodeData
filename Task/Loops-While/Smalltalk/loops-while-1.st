[s atEnd] whileFalse: [s next. ...].
[foo notNil] whileTrue: [s next. ...].
[...] doWhile: [ ... someBooleanExpression ].
[...] doUntil: [ ... someBooleanExpression ].
[:exit | ... cold ifTrue:[exit value]. ...] loopWithExit
