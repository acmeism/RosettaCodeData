REBOL [
    Title: "Fisher-Yates"
    Purpose: {Fisher-Yates shuffling algorithm}
]

fisher-yates: func [b [block!] /local n i j k] [
    n: length? b: copy b
    i: n
    while [i > 1] [
        if i <> j: random i [
            error? set/any 'k pick b j
            change/only at b j pick b i
            change/only at b i get/any 'k
        ]
        i: i - 1
    ]
    b
]
