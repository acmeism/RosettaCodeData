Rebol [
    title: "Rosetta code: Long multiplication"
    file:  %Long_multiplication.r3
    url:   https://rosettacode.org/wiki/Long_multiplication
]

multiply-big: function [
    "Multiply two big integers represented as strings"
    sa [string!] sb [string!]
][
    neg?: (sa/1 = #"-") xor (sb/1 = #"-")
    if sa/1 = #"-" [sa: next sa]
    if sb/1 = #"-" [sb: next sb]
    len-a: length? sa
    len-b: length? sb
    sr: append/dup copy "" #"0" len-a + len-b
    for i len-a 1 -1 [
        for j len-b 1 -1 [
            a: -48 + sa/:i ;; char to number
            b: -48 + sb/:j
            p2: i + j
            p1: p2 - 1
            p: (a * b) + (-48 + sr/:p2)
            sr/:p2: #"0"   + (p % 10) ;; digit
            sr/:p1: sr/:p1 + (p / 10) ;; carry
        ]
    ]
    parse sr [remove some #"0"] ;; remove zeros from the head
    case [
        empty? sr [insert sr #"0"]
        neg?      [insert sr #"-"]
    ]
    sr
]
foreach [a b][
    "18446744073709551616" "0"
    "18446744073709551616" "1"
    "18446744073709551616" "18446744073709551616"
    "18446744073709551616" "-18446744073709551616"
][
    print [a "*" b "=" multiply-big a b]
]
