no-connection-puzzle: function [][
    points:   [a b c d e f g h]
    links:    [a c a d a e b d b e b f c d c g d e d g d h e f e g e h f h]
    all-pegs: [1 2 3 4 5 6 7 8]

    connected?: func [x y][all [
        0 != (x * y)          ;; both non-zero
        1 == absolute (x - y) ;; adjacent (differ by 1)
    ]]

    valid?: function [
        pegs [block!]
    ][
        ;; Assign peg values to named points
        set points append/dup copy pegs 0 8
        ;; return false if any linked pair is connected
        foreach [x y] links [
            if connected? get x get y [return false]
        ]
        true
    ]

    ;; Recursively extend valid peg placements; record complete solutions
    check: function [
        pegs [block!]
    ][
        if valid? pegs [
            rest: difference all-pegs pegs
            either empty? rest [
                append/only solutions pegs
            ][
                foreach peg rest [check append copy pegs peg]
            ]
        ]
    ]
    solutions: copy []
    check [] ; start with an empty placement
    new-line/all solutions on
]

print-solution: function [p][
    print reword {
         $A   $B
        /│\ /│\
       / │ X │ \
      /  │/ \│  \
     $C───$D───$E───$F
      \  │\ /│  /
       \ │ X │ /
        \│/ \│/
         $G   $H
    }
    [a: p/1 b: p/2 c: p/3 d: p/4 e: p/5 f: p/6 g: p/7 h: p/8]
]

solutions: no-connection-puzzle
print "First solution:"
print-solution solutions/1

print ["All solutions:" mold solutions]
