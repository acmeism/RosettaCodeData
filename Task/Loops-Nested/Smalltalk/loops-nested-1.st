|i|

i := 1.
[:exit |
    Transcript showCR:i.
    i == 5 ifTrue:[ exit value:'stopped' ].
    i := i + 1.
] loopWithExit
