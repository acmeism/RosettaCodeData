Red [
	Title: "Long multiplication"
	Author: "hinjolicious"
	Resources: "Red Sensei"
]

; Simple long multiplication
multiply-big: function [sa [string!] sb [string!]] [
    "Multiply two big integers represented as strings"
    len-a: length? sa
    len-b: length? sb

    ; Initialize result array with zeros
    sr: to-string append/dup copy [] 0 (len-a + len-b)

    ; Multiply each digit
    i: len-a
    while [i > 0] [
        j: len-b
        while [j > 0] [
            a: (to-integer sa/:i) - 48
            b: (to-integer sb/:j) - 48

            p1: i + j - 1
            p2: i + j

            p: (a * b) + ((to-integer sr/:p2) - 48)

            sr/:p2: to-char (p % 10) + 48
            sr/:p1: to-char ((to-integer sr/:p1) + (p / 10))

            j: j - 1
        ]
        i: i - 1
    ]
	trim/with sr #"0"
]

print multiply-big "18446744073709551616" "18446744073709551616"
