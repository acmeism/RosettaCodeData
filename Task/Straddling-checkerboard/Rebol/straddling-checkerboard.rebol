Rebol [
    title: "Rosetta code: Straddling checkerboard"
    file:  %Straddling_checkerboard.r3
    url:   https://rosettacode.org/wiki/Straddling_checkerboard
]

register-codec [
    name:  'straddle
    type:  'cryptography
    title: "Straddling checkerboard"

    T: [
        ["79"  #"0" #"1" #"2" #"3" #"4" #"5" #"6" #"7" #"8" #"9"]
        [""    #"H" #"O" #"L" ""   #"M" #"E" #"S" ""   #"R" #"T"]
        [#"3"  #"A" #"B" #"C" #"D" #"F" #"G" #"I" #"J" #"K" #"N"]
        [#"7"  #"P" #"Q" #"U" #"V" #"W" #"X" #"Y" #"Z" #"." #"/"]
    ]

    header:  T/1  ;; digit labels for each column
    singles: T/2  ;; single-digit letters (H O L M E S R T)
    row3:    T/3  ;; two-digit letters starting with 3
    row4:    T/4  ;; two-digit letters starting with 7

    encode: function [
        {Encode plaintext using the straddling checkerboard.
        Single-digit letters (row 2) encode to one digit;
        all others encode to two digits (row prefix + column digit).}
        plaintext [string!]
    ][
        result: copy ""
        foreach ch plaintext [
            foreach row (next T) [                     ;; skip header row
                if col: index? find row ch [
                    repend result [row/1 header/:col]  ;; row prefix ("" for singles) +  column digit
                    break
                ]
            ]
        ]
        result
    ]

    decode: function [
        {Decode a straddling checkerboard ciphertext back to plaintext.
        Reads one digit at a time; if it matches a row prefix (3 or 7)
        the next digit selects the column in that row.}
        ciphertext [string!]
    ][
        result: copy ""
        pos: 1
        while [pos <= length? ciphertext] [
            digit: ciphertext/(++ pos)
            append result case [
                digit == row3/1 [                       ;; escape digit 3 -> read next for row3
                    digit: ciphertext/(++ pos)
                    letter: row3/(2 + digit - #"0")
                    if letter == #"/" [++ pos]
                    letter
                ]
                digit == row4/1 [                       ;; escape digit 7 -> read next for row4
                    digit: ciphertext/(++ pos)
                    row4/(2 + digit - #"0")
                ]
                true [                                 ;; single-digit: look up in singles row
                    singles/(2 + digit - #"0")
                ]
            ]
        ]
        result
    ]
]

plaintext: "One night-it was on the twentieth of March, 1888-I was returning"
encoded:   encode 'straddle plaintext
decoded:   decode 'straddle encoded

print ["Original:" plaintext]
print ["Encoded: " encoded  ]
print ["Decoded: " decoded  ]
