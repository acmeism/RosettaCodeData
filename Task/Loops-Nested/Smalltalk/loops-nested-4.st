|v result|

v := 1 to:20 collect:[:i |
        1 to:20 collect:[:j | Random nextIntegerBetween:1 and:20 ]
     ].

result :=
    [:exit |
        1 to:20 do:[:row |
            1 to:20 do:[:col |
                |element|

                (element := (v at:row) at:col) printCR.
                element == 20 ifTrue:[ exit value:(row @ col) ].
            ]
        ].
        nil
    ] valueWithExit.

result isNil ifTrue:[
    'ouch - no 20 found' printCR.
] ifFalse:[
    '20 found at ' print. result printCR
]
