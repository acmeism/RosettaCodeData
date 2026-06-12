Red[]

words: read/lines %unixdict.txt
forbidden: charset "aiou"

foreach word words [
    e's: 0
    retain: yes
    foreach char word [
        if find forbidden char [retain: no break]
        if #"e" = char [e's: e's + 1]
    ]
    if all [retain e's > 3] [print word]
]
