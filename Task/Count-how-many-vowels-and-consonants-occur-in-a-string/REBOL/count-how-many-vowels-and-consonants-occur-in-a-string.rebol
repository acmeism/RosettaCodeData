vowels-consonants: function/with [
    "Count number of vowels and consonants in a string"
    string [any-string!]
][
    vowels: consonants: 0
    parse string [any [
          consonant (consonants: consonants + 1)
        | vowel     (vowels: vowels + 1)
        | skip
    ]]
    reduce [vowels consonants]
][
    vowel:     charset "aeiou"
    consonant: charset "bcdfghjklmnpqrstvwxyz"
]

string: "Count how many vowels and consonants occur in a string"
counts: vowels-consonants string
print [mold string "has" counts/1 "vowels and" counts/2 "consonants"]
