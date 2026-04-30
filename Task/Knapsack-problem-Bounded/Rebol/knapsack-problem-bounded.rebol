Rebol [
    title: "Rosetta code: Knapsack problem/Bounded"
    file:  %Knapsack_problem-Bounded.r3
    url:   https://rosettacode.org/wiki/Knapsack_problem/Bounded
]

solve-knapsack: function/with [
    "Solves the bounded knapsack problem via top-down dynamic programming."
    limit [integer!]  "remaining weight capacity"
    pos   [integer!]  "current item index (0-based)"
][
    ;; Returns a 3-element block [value weight taken] where `taken` is a
    ;; block of per-item counts (parallel to `items`) representing the
    ;; optimal selection, or none if nothing fits.

    ;; Results are memoised in `cache` keyed by "limit,pos" so each
    ;; sub-problem is solved at most once.

    if any [pos < 0  limit <= 0] [                                ;; base case: no items or no capacity
        return reduce [0 0 none]
    ]

    key-str: rejoin [limit "," pos]
    if cached: cache/:key-str [ return cached ]                   ;; memoisation hit

    item: items/(pos + 1)                                         ;; [name weight value max-qty]
    best-value:  0
    best-weight: 0
    best-count:  0
    best-taken:  none

    taken: 0
    while [all [taken * item/2 <= limit  taken <= item/4]] [      ;; try 0..max-qty copies
        sub: solve-knapsack (limit - (taken * item/2)) (pos - 1)  ;; best for remaining items
        sub-value:  sub/1
        sub-weight: sub/2
        sub-taken:  sub/3
        candidate-value: sub-value + (taken * item/3)
        if candidate-value > best-value [                         ;; keep best combination found so far
            best-value:  candidate-value
            best-weight: sub-weight
            best-count:  taken
            best-taken:  sub-taken
        ]
        ++ taken
    ]

    if best-count > 0 [
        new-taken: make block! num-items       ;; copy before mutating to avoid aliasing cached entries
        repeat k num-items [append new-taken 0]
        if block? best-taken [
            repeat k num-items [new-taken/:k: best-taken/:k]
        ]
        new-taken/(pos + 1): best-count        ;; record how many of this item we take
        best-weight: best-weight + (best-count * item/2)
        best-taken: new-taken
    ]

    result: reduce [best-value best-weight best-taken]
    cache/(key-str): result                    ;; store [value weight taken-counts] in memo
    result
][
    cache: make map! 2000                      ;; memoisation table, shared across calls
]

items: [
    ["map"             9  150 1]
    ["compass"        13   35 1]
    ["water"         153  200 2]
    ["sandwich"       50   60 2]
    ["glucose"        15   60 2]
    ["tin"            68   45 3]
    ["banana"         27   60 3]
    ["apple"          39   40 3]
    ["cheese"         23   30 1]
    ["beer"           52   10 3]
    ["suntancream"    11   70 1]
    ["camera"         32   30 1]
    ["T-shirt"        24   15 2]
    ["trousers"       48   10 2]
    ["umbrella"       73   40 1]
    ["w-trousers"     42   70 1]
    ["w-overclothes"  43   75 1]
    ["note-case"      22   80 1]
    ["sunglasses"      7   20 1]
    ["towel"          18   12 2]
    ["socks"           4   50 1]
    ["book"           30   10 2]
]
item-name:   func [item] [item/1]
item-weight: func [item] [item/2]
item-value:  func [item] [item/3]
item-limit:  func [item] [item/4]

num-items: length? items
result: solve-knapsack 400 (num-items - 1)

total-value:  result/1
total-weight: result/2
taken:        result/3

print "Taking:"
if block? taken [
    repeat i num-items [
        count: pick taken i
        if count > 0 [
            item: pick items i
            print [" " count "of" item-limit item " " item-name item]
        ]
    ]
]
print ajoin ["Value: " total-value "; weight: " total-weight]
