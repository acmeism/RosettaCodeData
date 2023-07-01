[:exit |
    |first|

    Stdout printCR: (first := Random nextIntegerBetween:0 and:19).
    first == 10 ifTrue:exit.
    Stdout print:' '; printCR: (Random nextIntegerBetween:0 and:19).
] loopWithExit.
