Red []

bf: function [prog [string!]][
    size: 30000
    cells: make string! size
    append/dup cells null size

    parse prog [
        some [
              ">" (cells: next cells)
            | "<" (cells: back cells)
            | "+" (cells/1: cells/1 + 1)
            | "-" (cells/1: cells/1 - 1)
            | "." (prin cells/1)
            | "," (cells/1: first input "")
            | "[" [if (cells/1 = null) thru "]" | none]
            | "]" [
                pos: if (cells/1 <> null)
                (pos: find/reverse pos #"[") :pos
                | none
                ]
            | skip
        ]
    ]
]

; This code will print a Hello World! message
bf {
    ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.
    >++.<<+++++++++++++++.>.+++.------.--------.>+.>.
}
