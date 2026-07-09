Rebol [
    title: "Rosetta code: Prime conspiracy"
    file:  %Prime_conspiracy.r3
    url:   https://rosettacode.org/wiki/Prime_conspiracy
]

prime-conspiracy: function [
    "Return map of frequencies for final digits of consecutive primes"
    limit [integer!]
][
    freq: #[1 #[] 2 #[3 1] 3 #[] 5 #[] 7 #[] 9 #[]] ;; 2->3 transition pre-seeded
    count: 2                                        ;; 2 and 3 already counted
    last: x: 3
    while [count < limit] [
        x: x + 2
        if prime? x [
            ending: x % 10
            row: freq/:last
            row/:ending: 1 + any [row/:ending 0]
            last: ending
            count: count + 1
        ]
    ]
    freq
]

limit: 1000000
t: prime-conspiracy limit

for a 1 9 1 [
    for b 1 9 1 [
        if all [row: t/:a  row/:b] [
            print ajoin [
                a " -> " b "^-count: " row/:b
                "^-frequency: " round/to row/:b / limit * 100 0.0001 "%"
            ]
        ]
    ]
]
