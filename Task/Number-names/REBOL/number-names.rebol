Rebol [
    title: "Rosetta code: Number names"
    file:  %Number_names.r3
    url:   https://rosettacode.org/wiki/Number_names
]

wordify: function/with [
    "Convert integer to English words"
    number [integer!]
][
    if number < 0 [
        return ajoin ["negative " wordify negate number]
    ]
    if number < 20 [
        return small/(number + 1)
    ]
    if number < 100 [
        d: number // 10                         ;; tens digit
        m: number % 10                          ;; ones digit
        return ajoin [
            tens/(d + 1)
            if m > 0 [ajoin ["-" wordify m]]
        ]
    ]
    if number < 1000 [
        d: number // 100                        ;; hundreds digit
        m: number % 100                         ;; remainder
        return ajoin [
            small/(d + 1) " hundred"
            if m > 0 [ajoin [" and " wordify m]]
        ]
    ]
    chunks: copy []
    n: number
    while [n > 0] [
        append chunks n % 1000                  ;; extract 3-digit chunk
        n: n // 1000
    ]
    if (length? chunks) > length? big [
        return "integer value too large"
    ]
    words: copy []
    repeat i length? chunks [
        ch:    chunks/:i
        scale: big/:i
        if ch > 0 [
            chunk-str: wordify ch
            append words either empty? scale [
                chunk-str
            ][
                ajoin [chunk-str SP scale]
            ]
        ]
    ]
    ajoin/with reverse words ", "
][
    small: [
        "zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten"
        "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen"
        "eighteen" "nineteen"
    ]
    tens: [
        "" "" "twenty" "thirty" "forty"
        "fifty" "sixty" "seventy" "eighty" "ninety"
    ]
    big: copy ["" "thousand"]
    foreach p ["m" "b" "tr" "quadr" "quint" "sext" "sept" "oct" "non" "dec"] [
        append big ajoin [p "illion"]
    ]
]

foreach num [
    0 1 4 5 10 15 18 25 83 140 300 678 1024
    45039 123456 91740274651983
    -83125311200 -12 -7
][
    print [pad num -15 "|" wordify num]
]
