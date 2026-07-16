Rebol [
    title: "Rosetta code: Elementary cellular automaton"
    file:  %Elementary_cellular_automaton.r3
    url:   https://rosettacode.org/wiki/Elementary_cellular_automaton
]

eca: function [
    "Simulates an Elementary Cellular Automaton and prints each generation."
    nrule [integer!] "Wolfram rule number (0-255)"
    state [string! ] "Initial state string of '0'/'1' characters"
    gens  [integer!] "Number of generations to evolve"
][
    print ["^/ECA Rule:" nrule "Gens:" gens]

    rule:     enbase nrule 2                 ;; 8-char binary string for the rule
    patterns: ["111" "110" "101" "100" "011" "010" "001" "000"]
    width:    length? state
    next-gen: append/dup clear "" SP width   ;; pre-allocated next-generation buffer

    ;; flat key-value block: [pattern bits, output bit, ...]
    rule-map: collect [
        repeat i 8 [
            keep patterns/:i
            keep rule/:i
        ]
    ]

    loop gens [
        print replace/all (replace/all copy state #"1" #"#") #"0" #"."
        repeat i width [
            ;; compute next state of cell i with wraparound boundaries
            if 1     > left:  i - 1 [left: width]
            if width < right: i + 1 [right: 1   ]
            next-gen/:i: select rule-map ajoin [state/:left state/:i state/:right]
        ]
        ;; swap buffers
        tmp:      state
        state:    next-gen
        next-gen: tmp
    ]
]

state: "0000000000000001000000000000000"
eca 90  copy state 50 7
eca 30  copy state 40 7
eca 122 copy state 40 7
