Rebol [
    title: "Rosetta code: Write language name in 3D ASCII"
    file:  %Write_language_name_in_3D_ASCII-v2.r3
    url:   https://rosettacode.org/wiki/Write_language_name_in_3D_ASCII
]

print-rebol-v2: closure/with [][
    repeat row height [
        line: append/dup clear "" SP height - row
        foreach glyph-lines all-lines [
            parse glyph-lines/:row [any [#"X" (append line "__/") | skip (append line "   ")]]
            append line "  " ;; space between letters
        ]
        print line
    ]
][
    all-lines: []
    foreach glyph [
        {XXX ^/X  X^/XXX ^/X X ^/X  X}
        {XXXX^/X   ^/XXX ^/X   ^/XXXX}
        {XXX ^/X  X^/XXX ^/X  X^/XXX }
        { XX ^/X  X^/X  X^/X  X^/ XX }
        {X   ^/X   ^/X   ^/X   ^/XXXX}
    ][ repend all-lines [split-lines glyph] ]
    height: width: 5
]
print-rebol-v2
