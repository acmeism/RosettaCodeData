Collection extend [
    power [
        ^(0 to: (1 bitShift: self size) - 1) readStream collect: [ :each || i |
            i := 0.
            self select: [ :elem | (each bitAt: (i := i + 1)) = 1 ] ]
    ]
].
