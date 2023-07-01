tree: aPoint length: aLength angle: anAngle
    | p a |

    (aLength > 10) ifTrue: [
        p := Pen new.
        p up.
        p goto: aPoint.
        p turn: anAngle.
        p down.
        5 timesRepeat: [
            p go: aLength / 5.
            p turn: 5.
        ].
        a := anAngle - 30.
        3 timesRepeat: [
            self tree: p location length: aLength * 0.7 angle: a.
            a := a + 30.
        ]
    ].

draw
    Display restoreAfter: [
        Display fillWhite.
        self tree: 700@700 length: 200 angle: 0.
    ]
