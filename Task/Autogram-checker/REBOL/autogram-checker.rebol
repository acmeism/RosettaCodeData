Rebol [
    title: "Rosetta code: Autogram checker"
    file:  %Autogram_checker.r3
    url:   https://rosettacode.org/wiki/Autogram_checker
]

validate-autogram: function/with [
    "Returns true if sentence is a valid autogram"
    sentence      [string!]
    /include-punct
    /verbose
][
    s: lowercase copy sentence

    ;; count actual character occurrences in sentence
    countable: either include-punct [countable-punct-chars][countable-chars]
    counts: make map! []
    foreach c countable [
        n: 0
        foreach sc s [if sc == c [ ++ n ]]
        if n > 0 [counts/:c: n]
    ]

    ;; parse sentence's self-description into counts
    matches: find-counts-and-chars/:include-punct s
    sentence-counts: make map! []
    foreach [number char] matches [
        ch: any [word-to-char/:char char/1]
        sentence-counts/:ch: words-to-num number
    ]

    if verbose [
        print ["Parsed sentence counts:" mold sentence-counts]
        print ["Function counts:"        mold counts]
    ]

    ;; compare actual counts to described counts
    valid: true
    foreach [ch n] counts [
        either sc: sentence-counts/:ch [
            remove/key sentence-counts ch
            either n == sc [
                if verbose [print [ch ":" sc "verified"]]
            ][
                valid: false
                print [ch ": INVALID. True count:" n ", Sentence says:" sc]
            ]
        ][
            valid: false
            print [ch ": Missing from sentence. True count:" n]
        ]
    ]

    unless empty? sentence-counts [
        valid: false
        print ["Sentence mentions chars not found by `validate`: " mold sentence-counts]
    ]

    valid
][
    countable-chars: "abcdefghijklmnopqrstuvwxyz"
    countable-punct-chars: join countable-chars ",-'.!"

    word-to-int: make map! [
        "zero"      0 "single"    1 "one"      1 "two"        2 "three"     3
        "four"      4 "five"      5 "six"      6 "seven"      7 "eight"     8
        "nine"      9 "ten"      10 "eleven"  11 "twelve"    12 "thirteen" 13
        "fourteen" 14 "fifteen"  15 "sixteen" 16 "seventeen" 17 "eighteen" 18
        "nineteen" 19 "twenty"   20 "thirty"  30 "forty"     40 "fifty"    50
        "sixty"    60 "seventy"  70 "eighty"  80 "ninety"    90
    ]

    word-to-char: make map! [
        "comma"      #","
        "hyphen"     #"-"
        "apostrophe" #"'"
        "period"     #"."
    ]

    words-to-num: function [
        "Convert one or two number words (possibly hyphen/space separated) to integer"
        words [string!]
    ][
        num: 0
        parts: split words charset "- "
        foreach part parts [num: num + any [word-to-int/:part 0]]
        num
    ]

    find-counts-and-chars: function [
        "Find all (number-word char) pairs described in sentence"
        sentence      [string!]
        /include-punct
    ][
        results: copy []
        parse sentence [
            any [
                [   ;; try two-word number (leading + single), then single
                    copy num-str: [
                        leading-number [#" " | #"-"] single-number
                        | single-number
                    ]
                    #" "
                    copy char-str: [
                        "comma" | "hyphen" | "apostrophe" | "period"
                        | 1 char-rule
                    ]
                    opt ["'s" | #"s"]
                    (repend results [num-str char-str])
                ]
                | skip
            ]
        ]
        results
    ]
    leading-number: [
        "twenty" | "thirty" | "forty" | "fifty" | "sixty" | "seventy" | "eighty" | "ninety"
    ]
    single-number: [
        "seventeen" | "thirteen" | "fourteen" | "eighteen" | "nineteen" | "fifteen" |
        "sixteen"   | "seventy"  | "single"   | "eleven"   | "twelve"   | "twenty"  |
        "thirty"    | "eighty"   | "ninety"   | "three"    | "seven"    | "eight"   |
        "forty"     | "fifty"    | "sixty"    | "zero"     | "four"     | "five"    |
        "nine"      | "one"      | "two"      | "six"      | "ten"
    ]
    char-rule: charset [#"a" - #"z" ",-'.!"]
]

sentences: [
    {This sentence employs two a's, two c's, two d's, twenty-eight e's,
    five f's, three g's, eight h's, eleven i's, three l's, two m's,
    thirteen n's, nine o's, two p's, five r's, twenty-five s's,
    twenty-three t's, six v's, ten w's, two x's, five y's, and one z.} #(false)

    {This sentence employs two a's, two c's, two d's, twenty eight e's,
    five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's,
    nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's,
    ten w's, two x's, five y's, and one z.} #(false)

    {Only the fool would take trouble to verify that his sentence was
    composed of ten a's, three b's, four c's, four d's, forty-six e's,
    sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's,
    four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's,
    forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's,
    eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens
    and, last but not least, a single !} #(true)

    {This pangram contains four as, one b, two cs, one d, thirty es, six fs,
    five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns,
    fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us,
    seven vs, eight ws, two xs, three ys, & one z.} #(false)

    {This sentence contains one hundred and ninety-seven letters: four a's,
    one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's,
    twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's,
    nineteen t's, six u's, seven v's, four w's, four x's, five y's,
    and one z.} #(false)

    {Thirteen e's, five f's, two g's, five h's, eight i's, two l's,
    three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's,
    six w's, four x's, two y's.} #(false)

    {Fifteen e's, seven f's, four g's, six h's, eight i's, four n's,
    five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's,
    three x's.} #(true)

    {Sixteen e's, five f's, three g's, six h's, nine i's, five n's,
    four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's,
    four z's.} #(false)
]

i: 0
foreach [sentence include-punct] sentences [
    i: i + 1
    print rejoin ["^/----------------- sentence " i " -----------------"]
    probe sentence
    valid?: validate-autogram/:include-punct :sentence
    print either valid? [as-green "Valid!"][as-red "Invalid!"]
]
