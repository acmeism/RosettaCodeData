!Block methodsFor:'looping'!
loopWithExit
    "the receiver must be a block of one argument.  It is evaluated in a loop forever,
     and is passed a block, which, if sent a value:-message, will exit the receiver block,
     returning the parameter of the value:-message. Used for loops with exit in the middle."

    |exitBlock|

    exitBlock := [:exitValue | ^ exitValue].
    [true] whileTrue:[ self value:exitBlock ]
