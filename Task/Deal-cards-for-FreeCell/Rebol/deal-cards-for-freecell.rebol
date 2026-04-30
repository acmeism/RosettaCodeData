Rebol [
    title: "Rosetta code: Deal cards for FreeCell"
    file:  %Deal_cards_for_FreeCell.r3
    url:   https://rosettacode.org/wiki/Deal_cards_for_FreeCell
]

deal-FreeCell: function/with [
    "Deal a FreeCell game by number"
    num [integer!]
][
    deck: copy ordered-deck
    state: num ; seed the MSLCG
    print ["^/Game:" as-green num]
    len: length? deck
    while [len > 0] [
        ;; pick random remaining card and swap to end
        choice: rng % len + 1
        swap (at deck choice) (at deck len)
        prin [" " take/last deck]
        -- len
        if 4 == mod len 8 [prin "^/"]
    ]
    print ""
][
    ordered-deck: []
    foreach r "A23456789TJQK" [foreach s "♣♦♥♠" [ append ordered-deck ajoin [r s] ] ]
    ;; Microsoft linear congruential generator
    state: 0
    rng: does [
        state: (state * 214013 + 2531011) & 0#7fffffff
        state >> 16
    ]
]

deal-FreeCell 1
deal-FreeCell 617
deal-FreeCell 1 + random 32000
