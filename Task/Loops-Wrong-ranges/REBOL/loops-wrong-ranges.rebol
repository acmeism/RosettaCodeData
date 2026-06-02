Rebol [
    title: "Rosetta code: Loops/Wrong ranges"
    file:  %Loops-Wrong_ranges.r3
    url:   https://rosettacode.org/wiki/Loops/Wrong_ranges
    needs: 3.0.0
]
make-range: function [start end step][
    res: copy []
    if zero? step [return none]
    for i start end step [
        append res i
    ]
]
foreach [start end step] [
   -2  2   1  ;Normal
   -2  2   0  ;Zero increment
   -2  2  -1  ;Increments away from stop value
   -2  2  10  ;First increment is beyond stop value
    2 -2   1  ;Start more than stop: positive increment
    2  2   1  ;Start equal stop: positive increment
    2  2  -1  ;Start equal stop: negative increment
    2  2   0  ;Start equal stop: zero increment
    0  0   0  ;Start equal stop equal zero: zero incremen
][
    ;; Using format to pad numbers
    prin format ["make-range" -3 -3 -3] reduce [start end step]
    prin " ;== "
    ;; Output 'make-range' function result
    probe make-range start end step
]
