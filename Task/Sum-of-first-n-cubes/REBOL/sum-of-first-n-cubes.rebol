Rebol [
    title: "Rosetta code: Sum of first n cubes"
    file:  %Sum_of_first_n_cubes.r3
    url:   https://rosettacode.org/wiki/Sum_of_first_n_cubes
]

sum-of-cubes: function [
    "Returns a block of running totals of cubes."
    num [integer!]
][
    sum: 0
    collect [
        keep sum ;; first is zero
        repeat i num [
            keep sum: i * i * i + sum
        ]
    ]
]
probe sum-of-cubes 50
