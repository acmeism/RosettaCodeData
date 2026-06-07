Rebol [
    title: "Rosetta code: Entropy"
    file:  %Entropy.r3
    url:   https://rosettacode.org/wiki/Entropy
]

entropy: function [
    "Compute Shannon entropy (bits) of a string"
    str [string!]
][
    freqs: clear #[]
    foreach c str [
        freqs/:c: 1 + any [freqs/:c 0]
    ]
    result: 0
    numlen: length? str
    foreach [c count] freqs [
        freq: count / numlen                 ;; relative frequency
        result: result - (freq * log-2 freq) ;; Shannon: -sum(p * log2(p))
    ]
    result
]

foreach str ["1111111111" "1111222222" "1223334444"][
    print ["The information content of" as-yellow str "is" as-green entropy str]
]
