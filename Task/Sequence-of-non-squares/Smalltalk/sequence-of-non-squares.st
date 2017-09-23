| nonSquare isSquare squaresFound |
nonSquare := [:n |
    n + (n sqrt) rounded
].
isSquare := [:n |
    n = (((n sqrt) asInteger) raisedTo: 2)
].
Transcript show: 'The first few non-squares:'; cr.
1 to: 22 do: [:n |
    Transcript show: (nonSquare value: n) asString; cr
].
squaresFound := 0.
1 to: 1000000 do: [:n |
    (isSquare value: (nonSquare value: n)) ifTrue: [
        squaresFound := squaresFound + 1
    ]
].
Transcript show: 'Squares found for values up to 1,000,000: ';
show: squaresFound asString; cr
