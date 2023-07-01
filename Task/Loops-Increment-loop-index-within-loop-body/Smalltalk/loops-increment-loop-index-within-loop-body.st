numFound := 0.
idx := 42.
[:exit |
    idx := idx + 1.
    idx isPrime ifTrue:[
        numFound := numFound + 1.
        '%d %20d\n' printf:{numFound . idx} on:Transcript.
        idx := idx + idx - 1.
        numFound == 42 ifTrue:exit
    ].
] loopWithExit.
