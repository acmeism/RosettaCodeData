1 to: 10 do: [:n |
    Transcript show: n asString.
    n < 10 ifTrue: [ Transcript show: ', ' ]
]
