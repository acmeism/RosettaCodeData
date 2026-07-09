Rebol [
    title: "Rosetta code: Words from neighbour ones"
    file:  %Words_from_neighbour_ones.r3
    url:   https://rosettacode.org/wiki/Words_from_neighbour_ones
]

;; load words of 9+ chars from dictionary
words: make block! 25000
foreach word read/lines %unixdict.txt [
    if word/length >= 9 [
        append words word
    ]
]

;; check diagonal words: take i-th char from (n+i)-th word
words: make hash! words
for n 0 (length? words) - 9 1 [
    word: clear ""
    repeat i 9 [
        append word words/(n + i)/:i
    ]
    if find words word [print word]
]
