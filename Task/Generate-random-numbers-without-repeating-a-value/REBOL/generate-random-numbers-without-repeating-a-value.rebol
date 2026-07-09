Rebol [
    title: "Rosetta code: Generate random numbers without repeating a value"
    file:  %Generate_random_numbers_without_repeating_a_value.r3
    url:   https://rosettacode.org/wiki/Generate_random_numbers_without_repeating_a_value
]

generate: function [
    "Generates a block of integers from a to b in random order"
    a [integer!]
    b [integer!]
][
    assert [a < b]
    blk: make block! b - a      ;; pre-allocate exact size
    for i a b 1 [append blk i]  ;; fill with sequential integers
    random blk                  ;; shuffle in place
]

loop 5 [ probe generate 1 20 ]
