Rebol [
    title: "Rosetta code: Anadromes"
    file:  %Anadromes.r3
    url:   https://rosettacode.org/wiki/Anadromes
]

;; download word list if not cached locally
unless exists? %words.txt [
    write %words.txt
    read https://raw.githubusercontent.com/dwyl/english-words/refs/heads/master/words.txt
]
words: read/lines %words.txt
count: length? words

;; pre-filter: keep only lowercase words longer than 6 chars
filtered: make map! count / 2
foreach word words [
    if 6 < length? word [
        word: lowercase word
        filtered/:word: reverse copy word
    ]
]

print [count "words," length? filtered "> 6 characters."]

;; find anadromes: pairs where both word and its reverse exist in the filtered map
result: copy []
foreach [word reversed] filtered [
    if all [
        find/case filtered reversed   ;; reverse also exists as a word
        word < reversed               ;; avoid recording each pair twice
    ][
        repend result [word reversed]
    ]
]

print ["Found" (length? result) / 2 "anadromes:"]
foreach [word reversed] result [
    printf [-17 " ↔ "] [word reversed]
]
