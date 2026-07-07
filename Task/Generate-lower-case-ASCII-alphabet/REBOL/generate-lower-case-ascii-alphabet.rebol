Rebol [
    title: "Rosetta code: Generate lower case ASCII alphabet"
    file:  %Generate_lower_case_ASCII_alphabet.r3
    url:   https://rosettacode.org/wiki/Generate_lower_case_ASCII_alphabet
]

;; version 1:
for c 97 122 1 [prin to char! c]
print ""

;; version 2:
alphabet: charset [#"a" - #"z"]
repeat i length? alphabet [
    if alphabet/:i [prin to char! i]
]
print ""
