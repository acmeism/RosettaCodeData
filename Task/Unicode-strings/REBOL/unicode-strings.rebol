Rebol [
    title: "Rosetta code: Unicode strings"
    file:  %Unicode_strings.r3
    url:   https://rosettacode.org/wiki/Unicode_strings
]

text: "你好"

foreach [title code][
    "text"                  [text        ]
    "codepoints"            [text/length ]
    "column width"          [text/width  ]
    "contains string 好"    [did find text  "好"]
    "contains character 平" [did find text #"平"]
][
    printf [-25 " : "][title attempt code]
]
