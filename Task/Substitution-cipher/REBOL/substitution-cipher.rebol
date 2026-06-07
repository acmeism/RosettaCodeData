Rebol [
    title: "Rosetta code: Substitution cipher"
    file:  %Substitution_cipher.r3
    url:   https://rosettacode.org/wiki/Substitution_cipher
]

substitution: context [
    key: to string! debase {
XWtZVn0oITdQJG41XzBpIFI6P2pPV3RGLz0tcGUnQUQmQHI2JVpYcyJ2Kk5bI3dT
bDl6cTJeK2c7TG9CYGFHaHszLkhJdTRmYkspbVU4fGRNRVQ+PCxRY1xDMXl4Sg==} 64

    encode: function [
        "Encode a string using the substitution key."
        str [string!]
    ][
        out: copy str
        ;; map char -> key position
        forall out [
            change out key/(-31 + out/1)
        ]
        out
    ]

    decode: function [
        "Decode a string encoded with the substitution key."
        str [string!]
    ][
        out: copy str
        ;; reverse: key position -> char
        forall out [
            change out #"^_" + index? find/case key out/1
        ]
        out
    ]
]

plain: "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"

cipher: substitution/encode plain
print ["encoded:" cipher]
print ["decoded:" substitution/decode cipher]
