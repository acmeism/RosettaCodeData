Rebol [
    title: "Rosetta code: Hex dump"
    file:  %Hex_dump.r3
    url:   https://rosettacode.org/wiki/Hex_dump
]

hex-dump: function/with [
    "Print a binary value as a formatted hex dump."
    data [any-string! binary!]
    /part length [integer!] "Number of bytes to dump"
    /xxd "Use xxd binary-mode output (8-bit groups, 6 bytes per row)"
][
    unless  binary? data [data: to binary! data]
    offset: indexz? data
    if part [data: copy/part data length]
    clear out
    width: either xxd [6][gap-pos: 9 16]
    forskip data width [
        ;; offset column
        emit [pad/with enbase offset 16 -8 #"0" "  "]
        either xxd [
            ;; binary mode: 8 bits per byte, space-separated, no mid-gap
            repeat i width [
                emit [
                    either byte: data/:i [
                        either zero? byte ["00000000"][enbase byte 2]
                    ][  "        "]
                    space
                ]
            ]
        ][
            ;; hex bytes with mid-row gap
            repeat i width [
                emit [
                    if i = gap-pos [space]
                    either byte: data/:i [
                        either zero? byte ["00"][enbase byte 16]
                    ][  "  "]
                    space
                ]
            ]
        ]
        ;; ASCII column
        clear ascii
        repeat i width [
            unless byte: data/:i [break]
            append ascii either all [byte >= 32 byte <= 126] [to char! byte] [#"."]
        ]
        emit [" |" ascii "|^/"]
        offset: offset + width
    ]
    print out
][
    out: "" ascii: ""
    emit: func[v][append out ajoin v]
]


text: "Rosettacode is a programming crestomathy site 😀."
print [as-yellow "Using input text:" as-green text newline]
data: to binary! text

print as-yellow "Hex dump UTF-16BE, offset 0"
hex-dump iconv/to data 'UTF-8 'UTF-16BE

print as-yellow "Hex dump UTF-16LE, offset 0"
hex-dump iconv/to data 'UTF-8 'UTF-16LE

print as-yellow "Hex dump UTF-8, offset 17"
hex-dump at data 17

print as-yellow "Hex dump UTF-8, offset 18, part 11"
hex-dump/part at data 18 11

print as-yellow "Binary dump UTF-8, offset 17, part 24"
hex-dump/part/xxd at data 17 24
