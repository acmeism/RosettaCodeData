Red ["ASCII table"]

repeat i 16 [
    repeat j 6 [
        n: j - 1 * 16 + i + 31
        prin append pad/left n 3 ": "
        prin pad switch/default n [
            32 ["spc"]
            127 ["del"]
        ] [to-char n] 4
    ]
    prin newline
]
