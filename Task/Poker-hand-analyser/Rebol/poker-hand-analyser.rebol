Rebol [
    title: "Rosetta code: Poker hand analyser"
    file:  %Poker_hand_analyser.r3
    url:   https://rosettacode.org/wiki/Poker_hand_analyser
]

score-hand: function/with [
    "Poker hand analyser"
    hand [string!]
][
    hand: split hand SP
    if invalid? hand [return "invalid"]
    clear ranks
    clear suits
    foreach h hand [
        r: h/1 s: h/2
        ranks/:r: either ranks/:r [ranks/:r + 1][1]
        suits/:s: either suits/:s [suits/:s + 1][1]
    ]
    suit-values:      values-of suits
    rank-values: sort values-of ranks
    max-rank:    last rank-values
    case [
        straight-flush?  ["straight-flush"]
        four-of-a-kind?  ["four-of-a-kind"]
        full-house?      ["full-house"]
        flush?           ["flush"]
        straight?        ["straight"]
        three-of-a-kind? ["three-of-a-kind"]
        two-pair?        ["two-pair"]
        one-pair?        ["one-pair"]
        high-card?       ["high-card"]
        true             ["unclassified"]
    ]
][
    ranks: clear #[]
    suits: clear #[]
    suit-values: rank-values: max-rank: none
    ;; Build sorted deck
    sorted-deck: copy []
    foreach s "♣♦♥♠" [
        foreach r "23456789TJQKA" [
            append sorted-deck ajoin [r s]
        ]
    ]
    rank-modifiers: make map! [
        #"A" 130 #"K" 120 #"Q" 110 #"J" 100 #"T" 90
        #"9" 80  #"8" 70  #"7" 60  #"6" 50  #"5" 40
        #"4" 30  #"3" 20  #"2" 10
    ]
    has-duplicate?: function [deck] [
        (length? deck) != (length? unique copy deck)
    ]
    invalid?: func [hand] [
        any [
            not all map-each x hand [did find sorted-deck x]
            has-duplicate? hand
        ]
    ]
    straight?: function [] [
        if 1 != first find-max :rank-values [return false]
        mods: sort map-each x keys-of :ranks [rank-modifiers/:x]
        if mods = [10 20 30 40 130] [return true]
        while [not last? mods][
            if 10 < abs (mods/1 - mods/2) [return false]
            ++ mods
        ]
        true
    ]
    highest-suit?:    does [ last sort keys-of suits ]
    flush?:           does [ 1 = length? suit-values ]
    straight-flush?:  does [ all [straight? flush?]  ]
    four-of-a-kind?:  does [ 4 = max-rank            ]
    full-house?:      does [ [2 3] = rank-values     ]
    three-of-a-kind?: does [ all [3 = max-rank not full-house?] ]
    two-pair?:  does [ [2 2] = skip tail :rank-values -2 ]
    one-pair?:  does [ [1 2] = skip tail :rank-values -2 ]
    high-card?: does [ all [1 = max-rank not flush? not straight?] ]
]

foreach hand [
    "2♥ 2♦ 2♣ K♣ Q♦"
    "2♥ 5♥ 7♦ 8♣ 9♠"
    "A♥ 2♦ 3♣ 4♣ 5♦"
    "2♥ 3♥ 2♦ 3♣ 3♦"
    "2♥ 7♥ 2♦ 3♣ 3♦"
    "2♥ 7♥ 7♦ 7♣ 7♠"
    "T♥ J♥ Q♥ K♥ A♥"
    "4♥ 4♠ K♠ 5♦ T♠"
    "Q♣ T♣ 7♣ 6♣ 4♣"
    "X♣ T♣ 7♣ 6♣ 4♣"
][
    print ["Hand" as-yellow hand "is a" as-green score-hand hand "hand."]
]
