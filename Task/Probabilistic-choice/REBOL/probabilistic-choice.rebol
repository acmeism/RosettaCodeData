Rebol [
    title: "Rosetta code: Probabilistic choice"
    file:  %Probabilistic_choice.r3
    url:   https://rosettacode.org/wiki/Probabilistic_choice
]

random-choice: function [
    "Return a random item based on weighted probabilities"
    items [map!] "Map of item => probability pairs"
][
    z: random 1.0
    foreach [item prob] items [
        either z < prob [return item][z: z - prob]
    ]
    item ;; return last item as fallback for floating point rounding errors
]

items: make map! reduce [
    'aleph     1 / 5
    'beth      1 / 6
    'gimel     1 / 7
    'daleth    1 / 8
    'he        1 / 9
    'waw       1 / 10
    'zayin     1 / 11
    'heth   1759 / 27720
]
num-trials: 1000000
samples: copy items                          ;; start with same keys
foreach [key v] samples [samples/:key: 0]    ;; zero all counts

loop num-trials [
    key: random-choice items
    samples/:key: samples/:key + 1
]

foreach [item prob] items [
    printf [10 -8 "  " 9.000001 " "][
        item samples/:item  samples/:item / num-trials  prob
    ]
]
