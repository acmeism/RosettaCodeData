Rebol [
    title: "Rosetta code: Execute Brain****"
    file:  %Execute_Brainfuck.r3
    url:   https://rosettacode.org/wiki/Execute_Brain****
    note:  "Commented original Red version"
]

brainfuck: function [
    "Brainfuck interpreter - executes a Brainfuck program string"
    prog [string!]
][
    ; Initialize 30'000 memory cells (standard Brainfuck tape size)
    cells: make string! size: 30000
    append/dup cells null size  ;; Fill all cells with null (ASCII 0)

    ;; Parse and execute each Brainfuck instruction
    parse prog [
        some [
              #">" (cells: next cells)                    ;; Move tape pointer right
            | #"<" (cells: back cells)                    ;; Move tape pointer left
            | #"+" (cells/1: cells/1 + 1)                 ;; Increment current cell
            | #"-" (cells/1: cells/1 - 1)                 ;; Decrement current cell
            | #"." (prin cells/1)                         ;; Output current cell as character
            | #"," (cells/1: first input "")              ;; Read one character of input into current cell
            | #"[" [if (cells/1 = null) thru #"]" | none] ;; If current cell is 0, jump past matching "]"
            | #"]" [
                ;; If current cell is non-zero, jump back to matching "["
                 pos: if (cells/1 <> null)
                (pos: find/reverse pos #"[") :pos       ;; Seek backward to find "[", then jump to it
                | none                                  ;; Otherwise, do nothing and continue
            ]
            | skip  ;; Ignore any unrecognized characters
        ]
    ]
]

brainfuck {
    ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.
    >++.<<+++++++++++++++.>.+++.------.--------.>+.>.
}
