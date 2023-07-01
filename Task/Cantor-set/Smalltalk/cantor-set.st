Object subclass: CantorSet [

    | intervals |

    CantorSet class >> new
        [^self basicNew
            initialize;
            yourself]

    initialize
        [intervals := Array with: (CantorInterval
            from: 0
            to: 1)]

    split
        [intervals := intervals gather: [:each | each split]]

    displayOn: aStream atScale: aNumber
        [| current |
        current := 0.
        intervals do:
            [:each |
            (each start - current) * aNumber timesRepeat: [aStream space].
            each length * aNumber timesRepeat: [aStream nextPut: $#].
            current := each stop].
        aStream nl]
]

Interval subclass: CantorInterval [

    split
        [| oneThird left right |
        oneThird := self length / 3.
        left := self class
            from: start
            to: start + oneThird.
        right := self class
            from: stop - oneThird
            to: stop.
        ^Array
            with: left
            with: right]

    start  [^start]
    stop   [^stop]
    length [^stop - start]

    printOn: aStream
        [aStream << ('%1[%2,%3]' % {self class name. start. stop})]
]

Object subclass: TestCantor [

    TestCantor class >> iterations: anInteger
        [| cantorset scale count |
        scale := 3 raisedTo: anInteger. "Make smallest interval 1"
        count := 0.
        cantorset := CantorSet new.

        [cantorset
            displayOn: Transcript
            atScale: scale.
        count < anInteger] whileTrue:
            [cantorset split.
            count := count + 1]]
]

TestCantor iterations: 4.
