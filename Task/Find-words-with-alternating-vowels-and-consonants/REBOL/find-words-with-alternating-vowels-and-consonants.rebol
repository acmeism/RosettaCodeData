Rebol [
    title: "Rosetta code: Find words with alternating vowels and consonantse"
    file:  %Find_words_with_alternating_vowels_and_consonants.r3
    url:   https://rosettacode.org/wiki/Find_words_with_alternating_vowels_and_consonants
]

vowels: charset "aeiou"
count: 0
foreach word read/lines %unixdict.txt [
    len: length? word
    if len > 9 [
        first-is-vowel: find vowels word/1       ;; vowel/consonant class of first char
        ok?: true
        repeat i len [
            is-vowel: find vowels word/:i
            either odd? i [
                if is-vowel != first-is-vowel [ok?: false break]
            ][  if is-vowel == first-is-vowel [ok?: false break]]
        ]
        if ok? [
            ++ count
            prin pad word -14
            prin either count % 7 = 0 [newline][" "]
        ]
    ]
]
print ""
