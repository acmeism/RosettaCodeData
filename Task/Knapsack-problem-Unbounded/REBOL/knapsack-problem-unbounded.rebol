Rebol [
    title: "Rosetta code: Knapsack problem/Unbounded"
    file:  %Knapsack_problem-Unbounded.r3
    url:   https://rosettacode.org/wiki/Knapsack_problem/Unbounded
]

items: [
    [Panacea 3000 0.3  0.025]
    [Ichor   1800 0.2  0.015]
    [Gold    2500 2.0  0.002]
]

item-name:   func [item] [item/1]
item-value:  func [item] [item/2]
item-weight: func [item] [item/3]
item-volume: func [item] [item/4]

knapsack: function [
    {Solves the bounded knapsack problem with both weight and volume
    constraints, using brute-force recursion over item counts.}
    items  [block!]
    weight [number!]  ; remaining weight capacity
    volume [number!]  ; remaining volume capacity
][
    if empty? items [ return reduce [copy [] 0] ]

    n:    last-item: last items
    rest: copy/part items (length? items) - 1

    max-count: min  weight / item-weight n
                    volume / item-volume n
    best-value:  0
    best-counts: copy []

    count: 0
    while [count <= max-count] [
        sub: knapsack rest
                      weight - (count * item-weight n)
                      volume - (count * item-volume n)
        sub-counts: sub/1
        sub-value:  sub/2 + (count * item-value n)

        if sub-value > best-value [
            best-value:  sub-value
            best-counts: append copy sub-counts count
        ]
        ++ count
    ]

    reduce [best-counts best-value]
]

result:  knapsack items 25 0.25
counts:  result/1
sum-count: sum-value: sum-weight: sum-volume: 0

print "ITEM      COUNT  WEIGHT  VOLUME  VALUE"
print "--------------------------------------"
repeat i length? counts [
    item:   items/:i
    n:      counts/:i
    w:      n * item-weight item
    v:      n * item-volume item
    val:    n * item-value  item
    sum-count:  sum-count  + n
    sum-value:  sum-value  + val
    sum-weight: sum-weight + w
    sum-volume: sum-volume + v
    printf [10 7 8 8 8] reduce [item-name item  n  w  v val]
]
print "--------------------------------------"
printf [10 7 8 8 8] reduce ["TOTAL"  sum-count  sum-weight  sum-volume  sum-value]
