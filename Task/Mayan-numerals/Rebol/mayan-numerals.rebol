Rebol [
    title: "Rosetta code: Mayan numerals"
    file:  %Mayan_numerals.r3
    url:   https://rosettacode.org/wiki/Mayan_numerals
]

to-mayan: function/with [
    "Converts a decimal integer to its Mayan numeral representation as a string."
    number [integer!]
][
    vigs: dec2vig number                 ;; break number into vigesimal (base-20) digits
    mayans: map-each v vigs [vig2quin v] ;; convert each digit to a 4-row glyph
    draw mayans                          ;; render glyphs into a bordered string
][
    ;; Dot patterns for values 0–4 (index 1–5); used as the "ones" row of a glyph
    mayan: [
        "    "
        " ∙  "
        " ∙∙ "
        "∙∙∙ "
        "∙∙∙∙"
    ]
    m0: " Θ  "                           ;; special glyph for zero
    m5: "────"                           ;; horizontal bar representing five

    ;; Decomposes n into a block of base-20 digits, most-significant first.
    dec2vig: function [n [integer!]] [
        digits: copy []
        if n = 0 [return [0]]            ;; zero is a single digit: 0
        while [n > 0] [
            insert digits (n // 20)      ;; prepend the least-significant digit
            n: to integer! (n / 20)      ;; shift right in base 20
        ]
        digits
    ]
    ; Converts a single vigesimal digit (0–19) into a 4-element block of strings.
    ; Each element is one row of the glyph, top to bottom.
    vig2quin: function [n [integer!]] [
        if n >= 20 [do make error! "Can't convert a number >= 20"]
        res: reduce [mayan/1 mayan/1 mayan/1 mayan/1] ;; start with four blank rows
        if n = 0 [res/4: m0  return res]              ;; zero gets the shell glyph
        fives: to integer! (n / 5)       ;; number of five-bars needed (0–3)
        rem: n // 5                      ;; remaining dots above the bars (0–4)
        res/(4 - fives): mayan/(rem + 1) ;; place dot row just above the bars
        repeat i fives [
            res/(4 - fives + i): m5      ;; fill lower rows with five-bars
        ]
        res
    ]
    ;; Renders a block of glyphs into a single box-drawn string.
    ;; Each glyph is a 4-element block of fixed-width strings (one row each).
    draw: function/with [mayans [block!]] [
        lm: length? mayans
        out: copy ""
        emit ul
        repeat i lm [
            repeat j 4 [emit hb]
            emit either i < lm [uc][ur]
        ]
        repeat i 4 [
            emit vb
            repeat j lm [
                emit mayans/:j/:i
                emit vb
            ]
            emit LF
        ]
        emit ll
        repeat i lm [
            repeat j 4 [emit hb]
            emit either i < lm [lc][lr]
        ]
    ][  ;; Box-drawing characters; corners/bars include newlines where needed.
        ul: "╔"  uc: "╦"  ur: "╗^/" hb: "═"
        ll: "╚"  lc: "╩"  lr: "╝^/" vb: "║"
        out: none
        emit: func[s][append out s]
    ]
]

numbers: [4005 8017 326205 886205 1081439556]

foreach n numbers [
    print rejoin ["Converting " n " to Mayan:"]
    print to-mayan n
]
