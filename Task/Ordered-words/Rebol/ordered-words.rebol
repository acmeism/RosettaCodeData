Rebol [
    title: "Rosetta code: Ordered words"
    file:  %Ordered_words.r3
    url:   https://rosettacode.org/wiki/Ordered_words
]
;; Find all longest words in unixdict.txt that are already alphabetically sorted (non-decreasing letters)
;; Load or fetch the dictionary
unless exists? %unixdict.txt [
    write %unixdict.txt
    read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
words: read/lines %unixdict.txt
max: [""]  ;; initialize with one empty string (current best length = 0)
foreach word words [
    ;; If the word equals its sorted letters, it's alphabetically ordered; record its length, else -1
    len: either word = sort copy word [length? word] [-1]
    case [
        ;; Found an ordered word longer than the current best: start a new result block
        len > length? first max [
            max: reduce [word]
        ]
        ;; Found an ordered word with the same length as current best: add it to the results
        len = length? first max [
            append max word
        ]
    ]
]
;; Display the block of longest alphabetically ordered words
print [length? max "words found of length" length? max/1]
probe max
