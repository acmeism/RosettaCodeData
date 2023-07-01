| isPrime |
isPrime := [:n |
    n even ifTrue: [ ^n=2 ]
    ifFalse: [
        3 to: n sqrt do: [:i |
            (n \\ i = 0) ifTrue: [ ^false ]
        ].
        ^true
    ]
]
