Rebol [
    title: "Rosetta code: Write language name in 3D ASCII"
    file:  %Write_language_name_in_3D_ASCII.r3
    url:   https://rosettacode.org/wiki/Write_language_name_in_3D_ASCII
]

print-rebol: closure/with [][
    word: "REBOL"
    repeat row 6 [
        line: clear ""
        foreach char word [
            append line letters/:char/:row
        ]
        print line
    ]
][
    letters: [
        #"R" [
            "  ██████╗ "
            "  ██╔══██╗"
            "  ██████╔╝"
            "  ██╔══██╗"
            "  ██║  ██║"
            "  ╚═╝  ╚═╝"
        ]
        #"E" [
            "  ███████╗"
            "  ██╔════╝"
            "  █████╗  "
            "  ██╔══╝  "
            "  ███████╗"
            "  ╚══════╝"
        ]
        #"B" [
            "  ██████╗ "
            "  ██╔══██╗"
            "  ██████╔╝"
            "  ██╔══██╗"
            "  ██████╔╝"
            "  ╚═════╝ "
        ]
        #"O" [
            "  ██████╗ "
            "  ██╔══██╗"
            "  ██║  ██║"
            "  ██║  ██║"
            "  ╚█████╔╝"
            "   ╚════╝ "
        ]
        #"L" [
            "  ██╗     "
            "  ██║     "
            "  ██║     "
            "  ██║     "
            "  ███████╗"
            "  ╚══════╝"
        ]
    ]
]

print-rebol
