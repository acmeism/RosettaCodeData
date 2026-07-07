Rebol [
    title: "Rosetta code: Water collected between towers"
    file:  %Water_collected_between_towers.r3
    url:   https://rosettacode.org/wiki/Water_collected_between_towers
]

cum-max: function [
    "Return block of cumulative maximums from left to right"
    a [block!]
][
    m: a/1
    collect [foreach x a [m: max m x  keep m]] ;; running maximum so far
]

water-level: function [
    "Return block of water levels (min of left/right max walls)"
    a [block!]
][
    left:  cum-max a
    right: reverse cum-max reverse copy a
    collect [repeat i length? a [keep min left/:i right/:i]]
]

water: function [
    "Calculate total water trapped between elevation bars"
    a [block!]
][
    wl: water-level a
    sum: 0
    repeat i length? a [
        sum: sum + (max 0 wl/:i - a/:i) ;; water = min wall - ground
    ]
    sum
]

visualize: function [
    "Print ASCII visualization of trapped water"
    a [block!]
][
    wl: water-level a
    max-h: first find-max a
    repeat row max-h [
        h: max-h - row + 1         ;; current height level (top to bottom)
        line: clear ""
        repeat i length? a [
            append line case [
                a/:i >= h  ["██"]  ;; solid ground/wall
                wl/:i >= h ["≈≈"]  ;; trapped water
                true       ["  "]  ;; air
            ]
        ]
        print line
    ]
]

foreach a [
    [1 5 3 7 2]
    [5 3 7 2 6 4 5 9 1 2]
    [2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1]
    [5 5 5 5]
    [5 6 7 8]
    [8 7 7 6]
    [6 7 10 7 6]
][
    print [a "->" water a]
    visualize a
    print ""
]
