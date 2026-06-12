Rebol [
    title: "Rosetta code: Sort using a custom comparator"
    file:  %Sort_using_a_custom_comparator.r3
    url:   https://rosettacode.org/wiki/Sort_using_a_custom_comparator
]

lexicographic: func [
    "Compare two strings: longer first, then alphabetically within same length"
    a b
][
    la: length? a
    lb: length? b
    either la = lb [a < b][la > lb]
]
probe strings: split "Here are some sample strings to be sorted" space
probe sort/compare strings :lexicographic
