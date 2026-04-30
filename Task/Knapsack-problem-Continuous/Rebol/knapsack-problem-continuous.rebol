Rebol [
    title: "Rosetta code: Knapsack problem/Continuous"
    file:  %Knapsack_problem-Continuous.r3
    url:   https://rosettacode.org/wiki/Knapsack_problem/Continuous
]

knapsack: function [
    "Solves the fractional knapsack problem using a greedy algorithm."
    items      [block!]  "flat block of [name weight value] triples"
    max-weight [number!] "weight capacity of the knapsack"
][
    ;; build [name amount unit-value] triples, then sort by unit-value descending
    ranked: copy []
    foreach [name portion value] items [
        repend ranked [name portion value / portion]
    ]
    sort/skip/compare/reverse ranked 3 3  ;; skip=3 keeps triples together, compare on index 3

    total-wt: total-val: 0.0
    bagged: copy []

    foreach [name portion value] ranked [
        portion:   min (max-weight - total-wt) portion   ;; take all or whatever remains
        total-wt:  total-wt + portion
        added-val: portion * value
        total-val: total-val + added-val
        repend bagged [name portion round/to added-val 0.01]
        if total-wt >= max-weight [ break ]              ;; bag is full
    ]

    print "ITEM    PORTION   VALUE"
    foreach [name portion value] bagged [
        printf [10 8 8] reduce [name portion value]
    ]
    print [ "^/TOTAL WEIGHT:" total-wt
            "^/TOTAL VALUE:"  round/to total-val 0.01 ]
]

knapsack [
    "beef"    3.8 36.0
    "pork"    5.4 43.0
    "ham"     3.6 90.0
    "greaves" 2.4 45.0
    "flitch"  4.0 30.0
    "brawn"   2.5 56.0
    "welt"    3.7 67.0
    "salami"  3.0 95.0
    "sausage" 5.9 98.0
] 15
