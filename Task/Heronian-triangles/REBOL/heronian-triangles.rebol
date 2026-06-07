Rebol [
    title: "Rosetta code: Heronian triangles"
    file:  %Heronian_triangles.r3
    url:   https://rosettacode.org/wiki/Heronian_triangles
]

heronian-triangles: function/with [
    "Find all primitive Heronian triangles up to side length mx"
    mx [integer!]
][
    triangles: copy []
    repeat c mx [                               ; c is longest side
        repeat b c [                            ; b <= c
            a: max 1 c - b + 1                  ; triangle inequality lower bound for a
            while [a <= b][                     ; a <= b <= c (canonical order)
                if all [
                    heronian? area: hero a b c  ; integer area > 0
                    1 = gcd-list reduce [a b c] ; primitive: no common factor
                ][
                    repend/only triangles [     ; store as [a b c perimeter area]
                        a  b  c  a + b + c  to integer! area
                    ]
                ]
                ++ a
            ]
        ]
    ]
    triangles
][
    hero: function [
        ;; Heron's formula: area of triangle from side lengths
        a [integer!] b [integer!] c [integer!]
    ][
        s: (a + b + c) / 2.0                   ; semi-perimeter
        sqrt s * (s - a) * (s - b) * (s - c)
    ]

    heronian?: function [
        ;; True if x is a positive integer (i.e. area is whole number)
        x [number!]
    ][
        all [x > 0  x = round/ceiling x]
    ]

    gcd-list: function [
        ;; Greatest common divisor of a list of integers
        list [block!]
    ][
        g: list/1
        foreach x next list [g: gcd g x]       ; fold gcd over list
        g
    ]
]


print-table: function [title [string!] rows [block!]][
    "Print triangles as a formatted table with header"
    print as-yellow title
    print-hline/with/width #"=" 50
    printf [5 5 5 15 15]["A" "B" "C" "Perimeter" "Area"]
    print-hline/with/width #"-" 50
    foreach row rows [ printf [5 5 5 15 15] row ]
    print ""
]

triangles: heronian-triangles 200

print ["Number of Heronian triangles:" length? triangles]
print ""

;; Sort by area, then perimeter, then shortest side
sort/compare triangles func [x y][
    (x/5 * 10000 + (x/4 * 100) + x/1) < (y/5 * 10000 + (y/4 * 100) + y/1)
]

print-table "Ordered list of first ten Heronian triangles:"
    copy/part triangles 10

;; Filter to area = 210, keeping copy so triangles block is not modified
print-table "Ordered list of Heronian triangles with area 210:"
    remove-each row copy triangles [row/5 != 210]
