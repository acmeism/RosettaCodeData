agm:y
    "return the arithmetic-geometric mean agm(x, y)
     of the receiver (x) and the argument, y.
     See https://en.wikipedia.org/wiki/Arithmetic-geometric_mean"

    |ai an gi gn epsilon delta|

    ai := (self + y) / 2.
    gi := (self * y) sqrt.
    epsilon := self ulp.

    [
        an := (ai + gi) / 2.
        gn := (ai * gi) sqrt.
        delta := (an - ai) abs.
        ai := an.
        gi := gn.
    ] doUntil:[ delta < epsilon ].
    ^ ai
