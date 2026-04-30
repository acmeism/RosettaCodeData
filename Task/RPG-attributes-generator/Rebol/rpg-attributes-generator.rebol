Rebol [
    title: "Rosetta code: RPG attributes generator"
    file:  %RPG_attributes_generatot.r3
    url:   https://rosettacode.org/wiki/Bitmap/RPG_attributes_generatot
]

rpg-roll: function["RPG attributes generator"][
    ;; Repeat the entire stat-generation process until the quality thresholds are met
    until [
        values: copy []             ;; Ability scores for this attempt
        tot:    0                   ;; Running total of all six scores
        o15:    0                   ;; Count of scores that are 15 or above
        ;; Generate all six ability scores
        loop 6 [
            ;; Roll 4d6: collect four random results (1–6) into a temporary block
            tmp: clear [] loop 4 [append tmp random 6]
            ;; Drop the lowest die: sort ascending, skip the first value, sum the rest
            val: sum next sort tmp
            tot: tot + val          ;; Accumulate the total
            if val >= 15 [ ++ o15]  ;; Track high scores (over 14)
            append values val       ;; Store the final score
        ]
        ;; Accept this roll only if:
        ;; at least 2 scores are 15 or more AND total is at least 75
        all [o15 > 1 tot >= 75]
    ]
    reduce [tot values]
]

random/seed 1
loop 4 [
    set [total values] rpg-roll
    print [total mold values]
]
