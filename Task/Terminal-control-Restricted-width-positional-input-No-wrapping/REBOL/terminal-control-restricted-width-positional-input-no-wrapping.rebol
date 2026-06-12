Rebol [
    title: "Rosetta code: Terminal control/Restricted width positional input/No wrapping"
    file:  %Terminal_control-Restricted_width_positional_input-No_wrapping.r3
    url:   https://rosettacode.org/wiki/Terminal_control/Restricted_width_positional_input/No_wrapping
]

if function? :wait-for-key [wait-key: :wait-for-key] ;; backward compatibility

positioned-input: function [
    "Get user input at specific terminal position with max length"
    row    [integer!] "Row number (1-based)"
    col    [integer!] "Column number (1-based)"
    maxlen [integer!] "Maximum input length"
    return: [string!]
][
    input: copy ""
    pos: 1
    ;; Position cursor using ANSI escape sequence
    prin start-pos: ajoin ["^[[" row #";" col #"H"]
    ;; Draw input field (underscores show available space)
    prin ajoin ["^[[7m" append/dup clear "" #"_" maxlen "^[[0m"]
    ;; Return cursor to start of field
    prin start-pos
    ;; Input loop
    forever [
        ch: wait-key
        case [
            any [ch = CR ch = LF][ break ]
            any [ch = BS ch = 127][ ;; Backspace/DEL
                unless empty? input [
                    take/last input
                    pos: pos - 1
                    ;; Move back, reprint underscore, move back again
                    prin ajoin [
                        "^[[" row #";" col + pos - 1 #"H"
                        "^[[7m_^[[0m"
                        "^[[" row #";" col + pos - 1 #"H"
                    ]
                ]
            ]
            ;; Printable character within length limit
            all [maxlen > length? input char? ch ch >= 32 ch <= 126] [
                append input ch
                prin ajoin ["^[[7m" ch "^[[0m"]
                pos: pos + 1
            ]
            ;; Silently ignore input if at max length
        ]
    ]
    prin LF ;; Move cursor below the input field when done
    input
]

;; --- Main program ---

;; Clear screen and show instructions
prin  "^[[2J^[[1;1H"
print as-yellow "Terminal Positioned Input Rebol Demo"
print "(Input field appears below - max 8 characters)"
;; Get input at row 3, column 5, max width 8
result: positioned-input 3 5 8
;; Display the result
print ["You entered:" as-green result]
print ["Length:" as-green length? result "characters"]
