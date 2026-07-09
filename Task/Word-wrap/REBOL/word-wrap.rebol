Rebol [
    title: "Rosetta code: Word wrap"
    file:  %Word_wrap.r3
    url:   https://rosettacode.org/wiki/Word_wrap
    needs: 3.22.0
    note: "Could be optimized not splitting to words"
]

wrap-text: function [
    "Wrap text to a specified line width using a greedy algorithm"
    text      [string!] "Text to wrap"
    /width
     linewidth [integer!] "Maximum line width (default: 75)"
][
    unless width [linewidth: 75]
    words: split deline text charset " ^/"    ;; split on space/LF
    if empty? first words [remove words]      ;; drop leading empty token
    out: make string! text/length             ;; pre-alloc output buffer
    line: clear []                            ;; current line accumulator
    spaceleft: linewidth
    foreach word words [
        either word/width + 1 > spaceleft [   ;; word doesn't fit (display cols)
            append out ajoin/with line space  ;; flush current line
            append out newline
            append clear line word            ;; start new line with this word
            spaceleft: linewidth - word/width
        ][
            append line word                  ;; add word to current line
            spaceleft: spaceleft - word/width - 1
        ]
    ]
    append out ajoin/with line space          ;; flush last line
    trim/tail out                             ;; remove trailing newline/space
]

example: {
Even today, with proportional fonts and complex layouts,
there are still cases where you need to wrap text at a
specified column. The basic task is to wrap a paragraph
of text in a simple way in your language. If there is a
way to do this that is built-in, trivial, or provided in
a standard library, show that. Otherwise implement the
minimum length greedy algorithm from Wikipedia.
}

foreach width [75 50] [
    print-hline/width :width
    print wrap-text/width example :width
    print-hline/width :width
    print ""
]
