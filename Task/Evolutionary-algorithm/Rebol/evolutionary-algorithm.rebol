Rebol [
    title: "Rosetta code: Evolutionary algorithm"
    file:  %Evolutionary_algorithm.r3
    url:   https://rosettacode.org/wiki/Evolutionary_algorithm
    note:  "Based on Red language solution"
]

evolve: function/with [
    target [string!]  "target phrase to evolve toward"
    childs [integer!] "number of offspring per generation"
    rate   [number!]  "per-character mutation probability (0.0..1.0)"
][
    ;; create initial random parent of same length as target
    parent: clear ""
    repeat i length? target [
        append parent random/only alphabet
    ]
    ;; main loop: generate children, select fittest, repeat until exact match
    mutations: 0
    while [parent != target] [
        clear children
        repeat i childs [
            append children mutate parent rate  ;; produce a mutated child from parent
        ]
        sort/compare children :sort-fitness     ;; sort children by fitness (best first)
        parent: first children                  ;; select best child as new parent
        ++ mutations
        prin #"^M"                              ;; carriage return to overwrite line
        prin parent
    ]
    prin #"^M"                                  ;; move to line start
    print parent                                ;; final perfect match
    mutations
][
    alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ "     ;; allowed gene pool (uppercase letters + space)
    children: copy []                           ;; reusable buffer for a generation's children

    ;; compute closeness of 'string' to 'target' as Hamming distance (lower is better)
    fitness: function [string] [
        sum: 0
        repeat i length? string [
            if string/:i <> target/:i [ ++ sum ]  ;; count mismatched positions
        ]
        sum
    ]

    ;; return a mutated copy of 'string'; each position mutates with probability 'rate'
    mutate: function [string rate] [
        result: copy string
        repeat i length? result [
            if rate > random 1.0 [
                result/:i: random/only alphabet   ;; replace char with random from alphabet
            ]
        ]
        result
    ]

    ;; comparison function for sorting: a < b if fitness(a) < fitness(b)
    sort-fitness: function [a b] [lesser? fitness a fitness b]
]

;; run the evolution demo
random/seed 1
m: evolve "METHINKS IT IS LIKE A WEASEL" 20 0.05
print ["Target found using" as-yellow m "mutations."]
