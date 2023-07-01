Integer >> fibI
    |aNMinus1 an t|

    aNMinus1 := 1.
    an := 0.
    self timesRepeat:[
        t := an.
        an := an + aNMinus1 .
        aNMinus1 := t.
    ].
    ^ an
