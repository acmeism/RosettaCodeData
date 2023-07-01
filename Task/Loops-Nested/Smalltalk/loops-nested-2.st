|i|

i := 1.
[:exit1 |
    |j|

    j := 0.
    [:exit2 |
        Transcript showCR:('i is %1 / j is %2' bindWith:i with:j).
        j == 5 ifTrue:[ exit2 value: nil ].
        i == 5 ifTrue:[ exit1 value: nil ].
        j := j + 1.
    ] loopWithExit.
    i := i + 1
] loopWithExit
