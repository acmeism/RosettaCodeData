Rebol [
    title: "Rosetta code: Knapsack problem/0-1"
    file:  %Knapsack_problem-0-1.r3
    url:   https://rosettacode.org/wiki/Knapsack_problem/0-1
]

knapsack: function/with [
    "Solves the 0/1 knapsack problem via top-down dynamic programming."
    capacity   [integer!]  "remaining weight capacity"
    remaining  [block!]    "items not yet considered"
][
    ;;Each item may be taken at most once (unlike the bounded variant).
    ;;Returns a 3-element block [value weight items] representing the
    ;;optimal selection. Results are memoised in `cache` keyed by
    ;;"capacity,item-count" so each sub-problem is solved at most once.

    if empty? remaining [ return reduce [0 0 copy []] ]  ;; base case: no items left

    key: rejoin [capacity "," length? remaining]
    if cached: cache/:key [ return cached ]              ;; memoisation hit

    item:   first remaining
    rest:   next remaining
    name:   item/1
    weight: item/2
    value:  item/3

    skip-it: knapsack capacity rest                      ;; best result without this item

    result: either weight > capacity [
        skip-it                                          ;; item too heavy: must skip
    ][
        take-it: knapsack (capacity - weight) rest       ;; best result with this item
        take-value: take-it/1 + value
        either take-value > skip-it/1 [
            reduce [
                take-value
                take-it/2 + weight
                append copy take-it/3 item
            ]
        ][
            skip-it                                      ;; skipping is better
        ]
    ]

    cache/:key: result
    result
][
    cache: make map! 2000                                ;; memoisation table
]

items: [
    [map           9  150]
    [compass      13   35]
    [water       153  200]
    [sandwich     50  160]
    [glucose      15   60]
    [tin          68   45]
    [banana       27   60]
    [apple        39   40]
    [cheese       23   30]
    [beer         52   10]
    [cream        11   70]
    [camera       32   30]
    [t-shirt      24   15]
    [trousers     48   10]
    [umbrella     73   40]
    [trousers     42   70]
    [overclothes  43   75]
    [notecase     22   80]
    [glasses       7   20]
    [towel        18   12]
    [socks         4   50]
    [book         30   10]
]

result: knapsack 400 items

print "Bagged the following items:"
foreach [item weight value] result/3 [
    printf [" * " 12 -4 -4] reduce [item value weight]
]
print [
    "Total value  :" as-green result/1 LF
    "Total weight :" as-green result/2]
