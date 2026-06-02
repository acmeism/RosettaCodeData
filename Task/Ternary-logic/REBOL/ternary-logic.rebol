Rebol [
    title: "Rosetta code: Ternary logic"
    file:  %Ternary_logic.r3
    url:   https://rosettacode.org/wiki/Ternary_logic
]

maybe: 'maybe            ;; third truth value - unknown/undefined

ternary: context [
    not: func[a][
        either a = maybe [maybe][lib/not a]   ;; maybe propagates
    ]
    and: func[a b][
        case [
            all [a = true  b = true ] true    ;; both true → true
            any [a = false b = false] false   ;; either false → false
            'else                     maybe   ;; any maybe → maybe
        ]
    ]
    or: func[a b][
        case [
            any [a = true  b = true ] true    ;; either true → true
            all [a = false b = false] false   ;; both false → false
            'else                     maybe   ;; any maybe → maybe
        ]
    ]
    imp: func[a b][                           ;; material implication (a → b)
        case [
            a = true                  b       ;; true → b  =  b
            a = false                 true    ;; false → b  =  true
            b = true                  true    ;; a → true  =  true
            'else                     maybe   ;; uncertain antecedent/consequent
        ]
    ]
    eq: func[a b][
        case [
            a = b                     true
            any [a = maybe b = maybe] maybe   ;; unknown if either is maybe
            'else                     false
        ]
    ]
]
¬: :ternary/not
∧: make op! :ternary/and
∨: make op! :ternary/or
⊃: make op! :ternary/imp
≡: make op! :ternary/eq

values: reduce [true false maybe]

foreach [name op] [NOT ¬ AND ∧ OR ∨ IMP ⊃ EQ ≡] [
    print ["^/=== TERNARY" name "==="]
    foreach a values [
        either name = 'NOT [
            printf ["¬ " 6 "= "] [a ¬ a]
        ][
            foreach b values [
                printf [6 2 6 "= "][a op b try reduce [a op b]]
            ]
        ]
    ]
]
