Rebol [
    title: "Rosetta code: Hash join"
    file:  %Hash_join.r3
    url:   https://rosettacode.org/wiki/Hash_join
]

hash-join: function [t1 t2] [
    result: copy []
    foreach [age name] t1 [
        pos: t2
        while [pos: find/skip pos name 2][
            repend result [age name pos/1 pos/2]
            pos: skip pos 2
        ]
    ]
    new-line/skip result true 4
]

table1: [
    27 "Jonah"
    18 "Alan"
    28 "Glory"
    18 "Popeye"
    28 "Alan"
]

table2: [
    "Jonah" "Whales"
    "Jonah" "Spiders"
    "Alan"  "Ghosts"
    "Alan"  "Zombies"
    "Glory" "Buffy"
]

print hash-join table1 table2
