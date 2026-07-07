Rebol [
    title: "Rosetta code: One-dimensional cellular automata"
    file:  %One-dimensional_cellular_automata.r3
    url:   https://rosettacode.org/wiki/One-dimensional_cellular_automata
]

evolve: function [
    {Evolve a 1D cellular automaton string one generation.}
    petri [string!]
    rules [string!]
][
    temp: append clear "" petri ;; working copy
    repeat i length? petri [
        idx: 1                  ;; 3-bit lcr index into rules
            + (either petri/(i - 1) == #"#" [4] [0]) ;; left neighbour (dead at boundary)
            + (either petri/:i      == #"#" [2] [0])
            + (either petri/(i + 1) == #"#" [1] [0]) ;; right neighbour (dead at boundary)
        temp/:i: rules/:idx
    ]
    append clear petri temp
]


foreach [rules petri] [
    "...#.##."  ;; lcr-indexed: 000→. 001→. 010→. 011→# 100→. 101→# 110→# 111→.
    ".###.##.#.#.#.#..#.."

    ".#.##.#."  ;; lcr-indexed: 000→. 001→# 010→. 011→# 100→# 101→. 110→# 111→.
    ".........#........."
][
    print ["Using rules:" as-yellow mold rules]
    repeat i 10 [
        print ["Generation" i - 1 "|" as-green petri]
        evolve petri rules
    ]
    print-hline/width 35
]
