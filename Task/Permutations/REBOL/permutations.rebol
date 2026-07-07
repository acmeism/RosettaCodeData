Rebol [
    title: "Rosetta code: Permutations"
    file:  %Permutations.r3
    url:   https://rosettacode.org/wiki/Permutations
]

permutations: function [
    {Return block of all permutations of a block}
    items [block!]
][
    if single? items [return reduce [copy items]]
    result: copy []
    repeat i length? items [
        rest: copy items
        elem: take at rest i   ;; pick each element as head
        foreach perm permutations rest [
            repend result [append reduce [elem] perm]
        ]
    ]
    result
]
probe permutations [1 2 3]
probe new-line/all permutations ["aardvarks" "eat" "ants"] on
