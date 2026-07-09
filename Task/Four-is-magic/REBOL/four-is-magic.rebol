Rebol [
    title: "Rosetta code: Four is magic"
    file:  %Four_is_magic.r3
    url:   https://rosettacode.org/wiki/Four_is_magic
]

name-number: function/with [
    "Converts an integer to its English name"
    num [integer!]
][
    if num = 0 [return "zero"]
    absnum: abs num
    lion:   1
    while [absnum > 0] [
        word: copy ""
        o: absnum        % 10 + 1  ;; ones digit (1-based)
        t: absnum // 10  % 10 + 1  ;; tens digit (1-based)
        h: absnum // 100 % 10 + 1  ;; hundreds digit (1-based)
        word: case [
            t = 2  [teens/:o]                                         ;; 10-19
            t > 2  [ajoin [tens/:t  if o > 1 [ajoin [#"-" ones/:o]]]] ;; 20-99
            true   [ones/:o]                                          ;; 1-9
        ]
        if h > 1 [                 ;; prepend hundreds
            word: ajoin [
                ones/:h " hundred"
                if word [ajoin [SP word]]
            ]
        ]
        unless empty? word [       ;; prepend group with scale name (thousand, million...)
            result: ajoin [
                word
                if lions/:lion [ajoin [SP lions/:lion]]
                if result      [ajoin [SP result     ]]
            ]
        ]
        absnum: absnum // 1000     ;; next group of three digits
        ++ lion
    ]
    if num < 0 [insert result "negative "]
    result
][
    ones:  [_ "one" "two" "three" "four" "five" "six" "seven" "eight" "nine"]
    teens: ["ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen" "eighteen" "nineteen"]
    tens:  [_ _ "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety"]
    lions: [_ "thousand" "million" "billion" "trillion" "quadrillion" "quintillion" "sextillion" "septillion" "octillion" "nonillion" "decillion"]
]

four-is-magic: function/with [
    "Returns the four-is-magic chain for a number"
    num [integer!]
][
    uppercase/part chain num 1
][
    chain: func [n] [
        name: name-number n
        ajoin either/only n = 4 [
            name " is magic."                                            ;; termination
        ][  name " is " name-number name/length ", " chain name/length ] ;; recurse on letter count
    ]
]

numbers: [-21 -1 0 1 2 3 4 5 6 7 8 9 12 34 123 456 1024 1234 12345 123456 1010101]
foreach num numbers [
    print [as-green pad num -8  four-is-magic num]
]
