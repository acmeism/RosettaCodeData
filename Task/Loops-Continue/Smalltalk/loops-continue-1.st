1 to: 10 do: [ :i |
    [ :continue |
        i % 5 = 0 ifTrue: [
            Transcript show: i; cr.
            continue value ].
        Transcript
            show: i;
            show: ', '.		
    ] valueWithExit.
]
