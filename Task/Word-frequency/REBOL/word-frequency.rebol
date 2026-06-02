Rebol [
    title: "Rosetta code: Word frequency"
    file:  %Word_frequency.r3
    url:   https://rosettacode.org/wiki/Word_frequency
]

word-frequency: function/with [
    text [string! file! url!]
][
    dict: make map! 1000
    unless string? text [text: read/string text]
    parse text [
        any [
            copy word: some word-chars (
                word: lowercase word ;; normalize
                dict/:word: either n: dict/:word [n + 1][1]
            )
            | some skip-chars
        ]
    ]
    data: sort/reverse/skip/compare to block! dict 2 2
    new-line/skip data true 2
][
    word-chars: system/catalog/bitsets/alpha
    skip-chars: complement word-chars
]

;; Example:
unless exists? %135-0.txt [
    print "Downloading the test file: 135-0.txt"
    ;; Update timeout in case of slow connection.
    system/schemes/https/spec/timeout: 60
    write %135-0.txt read https://www.gutenberg.org/files/135/135-0.txt
]

probe copy/part word-frequency %135-0.txt 20
