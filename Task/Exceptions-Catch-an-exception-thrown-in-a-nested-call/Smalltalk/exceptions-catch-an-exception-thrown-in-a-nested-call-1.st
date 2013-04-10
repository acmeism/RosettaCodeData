| u0 u1 foo bar baz|

u0 := Signal new.
u1 := Signal new.

foo := [
         2 timesRepeat:[
             [ bar value ]
                 on: u0
                 do:[ 'u0 cought' printCR ]
         ]
       ].

bar := [
         baz value
       ].

baz := [
        |alreadyCalled|

        [
            alreadyCalled isNil ifTrue:[
                alreadyCalled := true. u0 raise
            ] ifFalse:[
                u1 raise
            ]
        ]
       ] value.

foo value
