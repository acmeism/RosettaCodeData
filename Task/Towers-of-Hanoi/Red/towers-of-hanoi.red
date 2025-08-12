Red [ "Towers of Hanoi - Hinjo, 20 July 2025" ]
hanoi: function [n src tgt aux] [
    if n > 0 [
        hanoi n - 1 src aux tgt
        print ["Move from " src " to " tgt]
        hanoi n - 1 aux tgt src
    ]
]
hanoi 5 "A" "C" "B"
