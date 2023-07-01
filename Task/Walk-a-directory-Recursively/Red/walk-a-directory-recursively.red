Red []

walk: func [
    "Walk a directory tree recursively, setting WORD to each file and evaluating BODY."

    'word              "For each file, set with the absolute file path."
    directory [file!]  "Starting directory."
    body      [block!] "Block to evaluate for each file, during which WORD is set."
    /where
    rules [block!]     "Parse rules defining file names to include."
][
    foreach file read directory [
        if where [if not parse file rules [continue]]
        either dir? file: rejoin [directory file] [walk item file body] [
            set 'word file
            do body
        ]
    ]
]

rules: compose [
    any (charset [#"A" - #"Z"])
    ".TXT"
]

walk/where file %/home/user/ [print file] rules
