Rebol [
    title: "Rosetta code: Integer sequence"
    file:  %Integer_sequence.r3
    url:   https://rosettacode.org/wiki/Integer_sequence
]

i: 0
try/with [
    forever [
        print i: i + 1
    ]
][
    print ["Maximum integer" i "reached!"]
]
