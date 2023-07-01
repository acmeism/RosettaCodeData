Object subclass: Nim [
    | tokens |
    <comment: 'I am a game of nim'>
    Nim class >> new [
        <category: 'instance creation'>
        ^(super new) init: 12
    ]

    init: t [
        <category: 'instance creation'>
        tokens := t.
        ^self
    ]


    pTurn [
        | take |
        <category: 'gameplay'>
        Transcript nextPutAll: 'How many tokens will you take?: '.
        take := (stdin nextLine) asNumber.
        ((take < 1) | (take > 3))
            ifTrue: [Transcript nextPutAll: 'Invalid input';nl;nl. self pTurn]
            ifFalse: [tokens := tokens - take]
    ]

    cTurn [
        | take |
        <category: 'gameplay'>
        take := tokens - (4 * (tokens // 4)).    "tokens % 4"
        Transcript nextPutAll: 'Computer takes '.
        take printOn: Transcript.
        Transcript nextPutAll: ' tokens';nl.
        tokens := tokens - take
    ]

    mainLoop [
        <category: 'main loop'>
        Transcript nextPutAll: 'Nim game';nl.
        Transcript nextPutAll: 'Starting with '.
        tokens printOn: Transcript.
        Transcript nextPutAll: ' tokens';nl;nl.
        1 to: 3 do: [ :n |    "The computer always wins on the 3rd turn"
            self pTurn.
            self printRemaining.
            self cTurn.
            self printRemaining.
            (tokens = 0)
                ifTrue:[Transcript nextPutAll: 'Computer wins!';nl. ^0]
        ]
    ]

    printRemaining [
        <category: 'information'>
        tokens printOn: Transcript.
        Transcript nextPutAll: ' tokens remaining';nl;nl
    ]
]

g := Nim new.
g mainLoop.
