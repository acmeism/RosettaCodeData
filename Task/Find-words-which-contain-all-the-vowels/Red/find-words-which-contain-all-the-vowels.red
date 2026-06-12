Red[]

vowels: charset "aeiou"

count-vowels: function [
    "Returns the number of vowels in a string"
    word [string!]
][
    result: 0
    foreach letter word [
        if find vowels letter [result: result + 1]
    ]
    result
]

foreach word read/lines %unixdict.txt [
    if all [
        10 < length? word
        5 = length? intersect word "aeiou"
        5 = count-vowels word
    ][
        print word
    ]
]
