Rebol [
    title: "Rosetta code: Euclidean rhythm"
    file:  %Euclidean_rhythm.r3
    url:   https://rosettacode.org/wiki/Euclidean_rhythm
]

generate-sequence: function [
    "Generate a sequence of length n with k ones using the Euclidean algorithm."
    k [integer!] n [integer!]
][
    seq: array/initial n []                      ;; n empty rows
    repeat i n [
        append seq/:i either i <= k [1] [0]      ;; first k rows get 1, rest get 0
    ]
    diff:   n - k
    major:  max k diff                           ;; larger partition
    minor:  min k diff                           ;; smaller partition
    remain: diff                                 ;; steps left to distribute
    while [any [remain > 0  minor > 1]] [
        repeat i minor [
            append seq/:i seq/(n + 1 - i)        ;; append mirror row
        ]
        clear skip seq n: n - minor              ;; drop consumed tail rows, update n
        remain: remain - minor
        diff:   major - minor
        major:  max minor diff
        minor:  min minor diff
    ]
    result: copy ""
    foreach row seq [ append result rejoin row ] ;; flatten
]

print [
    "Euclidean rhythm for (5, 13) is:"
    as-yellow generate-sequence 5 13
]
