Rebol [
    title: "Rosetta code: Draw a clock (CLI)"
    file:  %Draw_a_clock.r3
    url:   https://rosettacode.org/wiki/Draw_a_clock
]

;; two spaced-separated blocks of Braille-like glyphs (top and bottom halves for digits 0-9 and separator)
s: join { ⡎⢉⢵ ⠀⢺⠀ ⠊⠉⡱ ⠊⣉⡱ ⢀⠔⡇ ⣏⣉⡉ ⣎⣉⡁ ⠊⢉⠝ ⢎⣉⡱ ⡎⠉⢱ ⠀⠶ }
        { ⢗⣁⡸ ⢀⣸⣀ ⣔⣉⣀ ⢄⣀⡸ ⠉⠉⡏ ⢄⣀⡸ ⢇⣀⡸ ⢰⠁⠀ ⢇⣀⡸ ⢈⣉⡹ ⠀⠶ }
;; split the big string every 4 chars to get a block of 22 glyph cells (11 top + 11 bottom)
s: split s 4

forever [                               ;; loop to update the clock every second
    tm: format-date-time now "hh:mm:ss" ;; current time string, e.g., "12:34:56"
    l1: clear ""                        ;; buffer for the top line of the big digits
    l2: clear ""                        ;; buffer for the bottom line of the big digits
    foreach c tm [                      ;; for each character in the time string
        i: 1 + c - #"0"                 ;; convert digit char to 1-based index
        append l1 s/(i)                 ;; append top-half glyph for the digit (for ":" this will intentionally pick the separator at index 11)
        append l2 s/(i + 11)            ;; append bottom-half glyph (offset by 11 to access the lower row set)
    ]
    print l1                            ;; print top line of large digits
    print l2                            ;; print bottom line of large digits
    wait 1                              ;; pause one second
    prin "^[[2A"                        ;; move cursor up 2 lines (ANSI escape) to overwrite in place next iteration
]
