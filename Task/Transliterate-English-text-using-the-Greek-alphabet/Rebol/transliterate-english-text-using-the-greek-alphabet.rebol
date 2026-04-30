Rebol [
    title: "Rosetta code: Transliterate English text using the Greek alphabet"
    file: %Transliterate_English_text_using_the_Greek_alphabet.r3
    url: https://rosettacode.org/wiki/Transliterate_English_text_using_the_Greek_alphabet
]
transliterate-to-greek: function [
    "Transliterate text using the Greek alphabet."
    text [string!] "Text to transliterate (modified)"
][
    parse/case text [
        any [
            change "ch" #"χ" |
            change "th" #"θ" |
            change "ps" #"ψ" |
            change "ph" #"f" |
            change "Ch" #"Χ" |
            change "Th" #"Θ" |
            change "Ps" #"Ψ" |
            change "Ph" #"F" |
            change "ee" #"h" |
            change "ck" #"κ" |
            change "rh" #"r" |
            change "kh" #"χ" |
            change "Kh" #"Χ" |
            change "oo" #"w" |
            change #"a" #"α" |
            change #"b" #"β" |
            change #"c" #"κ" |
            change #"d" #"δ" |
            change #"e" #"ε" |
            change #"f" #"φ" |
            change #"g" #"γ" |
            change #"h" #"η" |
            change #"i" #"ι" |
            change #"j" #"ι" |
            change #"k" #"κ" |
            change #"l" #"λ" |
            change #"m" #"μ" |
            change #"n" #"ν" |
            change #"o" #"ο" |
            change #"p" #"π" |
            change #"q" #"κ" |
            change #"r" #"ρ" |
            change #"s" #"σ" |
            change #"t" #"τ" |
            change #"u" #"υ" |
            change #"v" #"β" |
            change #"w" #"ω" |
            change #"x" #"ξ" |
            change #"y" #"υ" |
            change #"z" #"ζ" |
            change #"D" #"Δ" |
            change #"F" #"Φ" |
            change #"G" #"Γ" |
            change #"J" #"I" |
            change #"L" #"Λ" |
            change #"P" #"Π" |
            change #"Q" #"Κ" |
            change #"R" #"Ρ" |
            change #"S" #"Σ" |
            change #"Y" #"U" |
            change #"W" #"Ω" |
            change #"X" #"Ξ" |
            skip
        ]
    ]
    text
]

print transliterate-to-greek
{I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio.}
