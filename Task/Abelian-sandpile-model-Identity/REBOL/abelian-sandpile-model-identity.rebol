Rebol [
    title: "Rosetta code: Abelian sandpile model/Identity"
    file:  %Abelian_sandpile_model-Identitys.r3
    url:   https://rosettacode.org/wiki/Abelian_sandpile_model/Identity
    note:  "Based on Red language solution"
]
sadd: context [
    ;; 'comb' adds two 3x3 piles cell by cell, then validates the result
    comb: function [pile1 [series!] pile2 [series!]] [
        ;; Loop over rows 1 to 3
        repeat r 3 [
            ;; Loop over columns 1 to 3
            repeat c 3 [
                ;; Add corresponding cell values from pile1 to pile2
                pile2/:r/:c: pile2/:r/:c + pile1/:r/:c
            ]
        ]
        ;; Validate and stabilize the resulting pile
        check pile2
    ]
    ;; 'check' ensures no cell exceeds threshold (4); if it does, it topples
    check: function [pile [series!]] [
        stable:   true  ;; Flag to track if pile is stable
        row: col: none  ;; Coordinates of any unstable cell
        ;; Scan the 3x3 grid for cells >= 4
        repeat r 3 [
            repeat c 3 [
                if pile/:r/:c >= 4 [
                    stable: false
                    ;; Subtract threshold from the unstable cell
                    pile/:r/:c: pile/:r/:c - 4
                    row: r col: c
                    break  ;; Exit inner repeat when found
                ]
            ]
            unless stable [break]  ;; Exit outer repeat if unstable cell found
        ]
        ;; If no unstable cell was found, print final pile and exit
        if stable [
            print trim/with mold/only pile "[]"
            print ""
            exit
        ]
        ;; Distribute ("spill") grains from the unstable cell to neighbors
        spill pile row col
    ]
    ;; 'spill' distributes one grain to each valid neighbor of (r, c)
    spill: function [pile [series!] r [integer!] c [integer!]] [
        ;; Define neighbor offsets: right, up, left, down
        neigh: reduce [
            right: reduce [r c - 1]
            up:    reduce [r + 1 c]
            left:  reduce [r c + 1]
            down:  reduce [r - 1 c]
        ]
        ;; For each neighbor coordinate pair 'n'
        foreach n neigh [
            ;; If neighbor cell exists (not off-grid), add one grain
            unless any [
                none? pile/(n/1)
                none? pile/(n/1)/(n/2)
            ][
                pile/(n/1)/(n/2): pile/(n/1)/(n/2) + 1
            ]
        ]
        ;; Re-check pile for further toppling
        check pile
    ]
]

s1: [
    [1 2 0]
    [2 1 1]
    [0 1 3]
]
s2: [
    [2 1 3]
    [1 0 1]
    [0 1 0]
]
s3: [
    [3 3 3]
    [3 3 3]
    [3 3 3]
]
s3_id: [
    [2 1 2]
    [1 0 1]
    [2 1 2]
]
ex: [
    [4 3 3]
    [3 1 2]
    [0 2 3]
]
print "Avalanche of topplings"
sadd/check copy/deep ex
print "Add s1 to s2"
sadd/comb copy/deep s1 copy/deep s2
print "Add s2 to s1"
sadd/comb copy/deep s2 copy/deep s1
print "Add s3 to s3_id"
sadd/comb copy/deep s3 copy/deep s3_id
print "Add s3_id to s3_id"
sadd/comb copy/deep s3_id copy/deep s3_id
