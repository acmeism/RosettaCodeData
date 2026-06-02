Rebol [
    title: "Rosetta code: Show ASCII table"
    file:  %Show_ASCII_table.r3
    url:   https://rosettacode.org/wiki/Show_ASCII_table
]

repeat i 16 [
    repeat j 6 [
        n: j - 1 * 16 + i + 31
        prin ajoin [
            pad n -3 ": "
            pad any [
                select [32 "Spc" 127 "Del"] n
                to char! n
            ] 4
        ]
    ]
    prin newline
]
