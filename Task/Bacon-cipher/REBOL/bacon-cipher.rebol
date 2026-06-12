Rebol [
    title: "Rosetta code: Bacon cipher"
    file:  %Bacon_cipher.r3
    url:   https://rosettacode.org/wiki/Bacon_cipher.r3
]

bacon: context [
    codes: [
        #"a" "AAAAA" #"b" "AAAAB" #"c" "AAABA" #"d" "AAABB" #"e" "AABAA"
        #"f" "AABAB" #"g" "AABBA" #"h" "AABBB" #"i" "ABAAA" #"j" "ABAAB"
        #"k" "ABABA" #"l" "ABABB" #"m" "ABBAA" #"n" "ABBAB" #"o" "ABBBA"
        #"p" "ABBBB" #"q" "BAAAA" #"r" "BAAAB" #"s" "BAABA" #"t" "BAABB"
        #"u" "BABAA" #"v" "BABAB" #"w" "BABBA" #"x" "BABBB" #"y" "BBAAA"
        #"z" "BBAAB" #" " "BBBAA" ;; space encodes any non-letter
    ]
    lower: charset [#"a" - #"z"]
    upper: charset [#"A" - #"Z"]
    not-alpha: complement union lower upper

    encode: function [
        "Hide plain-text inside message using letter case (Bacon's cipher)."
        plain   [string!]
        message [string!]
    ][
        ;; convert plain-text to Bacon bit-string (A/B sequence)
        bits: clear ""
        foreach c plain [
            append bits any [select codes c #" "]
        ]
        ;; encode bits into message: lowercase = A, uppercase = B
        out: copy ""
        parse message [
            collect into out some [
                  keep some not-alpha
                | if (tail? bits) break
                | p: skip keep (
                    either #"A" == first ++ bits [p/1][uppercase p/1]
                )
            ]
        ]
        out
    ]

    decode: function [
        "Extract hidden plain-text from a Bacon-encoded message."
        message [string!]
    ][
        ;; recover A/B bit-string from letter case
        bits: clear ""
        foreach c message [
            case [
                find/case lower c [append bits #"A"]
                find/case upper c [append bits #"B"]
            ]
        ]
        ;; decode each 5-bit quintet back to a character
        out: copy ""
        parse bits [
            any [
                copy quintet: 5 skip (
                    append out pick find codes quintet -1
                )
            ]
        ]
        out
    ]
]

plain: "the quick brown fox jumps over the lazy dog"
message: trim/auto {
    bacon's cipher is a method of steganography created by francis bacon.
    this task is to implement a program for encryption and decryption of
    plaintext using the simple alphabet of the baconian cipher or some
    other kind of representation of this alphabet (make anything signify anything).
    the baconian alphabet may optionally be extended to encode all lower
    case characters individually and/or adding a few punctuation characters
    such as the space.}


cipher: bacon/encode plain message
print as-yellow "Cipher text ->"
print cipher
print ""
print as-yellow "Hidden text ->"
print bacon/decode cipher
