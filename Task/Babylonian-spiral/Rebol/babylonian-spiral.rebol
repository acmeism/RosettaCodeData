Rebol [
    title: "Rosetta code: Babylonian spiral"
    file:  %Babylonian_spiral.r3
    url:   https://rosettacode.org/wiki/Babylonian_spiral
]

babylonian-spiral: function/with [
    "Get points along a Babylonian spiral of nsteps steps."
    nsteps [integer!]
][
    ;; Grow the shared square-cache if needed so index i holds i*i
    if nsteps > s: length? square-cache [
        for i s nsteps 1 [
            append square-cache i * i
        ]
    ]
    ;; Start with the origin and the first unit step along +y
    output: reduce [0x0 0x1]
    delta-squared: 1

    loop nsteps - 2 [
        ;; Heading of the last delta vector, in degrees
        theta: arctangent2 last output
        ;; Search increasing vector lengths until at least one integer candidate is found
        candidates: clear []
        while [empty? candidates] [
            ++ delta-squared
            ;; Enumerate all pairs (i,j) where i²+j²=delta-squared
            for i 0 (-1 + length? square-cache) 1 [
                a: pickz square-cache i
                if a > delta-squared / 2 [break]  ;; a <= delta-squared/2 by symmetry
                j: 1 + to integer! square-root delta-squared
                while [j >= 1] [
                    b: square-cache/(j + 1)
                    if delta-squared > a + b [break]  ;; j only decreases from here
                    if delta-squared = a + b [
                        ;; Add all 8 reflections of the (i,j) solution
                        -i: negate i
                        -j: negate j
                        repend candidates [
                            as-pair i  j  as-pair -i  j
                            as-pair i -j  as-pair -i -j
                            as-pair j  i  as-pair -j  i
                            as-pair j -i  as-pair -j -i
                        ]
                    ]
                    -- j
                ]
            ]
        ]
        ;; Pick the candidate whose heading deviates least clockwise from theta
        append output first sort/compare candidates func [da db] [
            angle-a: theta - arctangent2 da
            angle-b: theta - arctangent2 db
            ; Wrap into [0, 360) so smallest clockwise turn sorts first
            angle-a: angle-a % 360   if angle-a < 0 [angle-a: angle-a + 360]
            angle-b: angle-b % 360   if angle-b < 0 [angle-b: angle-b + 360]
            angle-a < angle-b
        ]
    ]
    ;; Convert delta sequence in-place to absolute positions by cumulative summation
    pos: 0x0 forall output [ change output pos: pos + output/1 ]
    output
][
    ;; Persistent square-cache shared across calls, initialised empty
    square-cache: clear []
]

; --- Main ---
print as-yellow "The first 40 points of the Babylonian spiral are:"
points: babylonian-spiral 40
while [not empty? points][ print [TAB take/part points 10] ]
