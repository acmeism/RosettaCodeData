Rebol [
    title: "Rosetta code: Natural sorting"
    file:  %Natural_sorting.r3
    url:   https://rosettacode.org/wiki/Natural_sorting
]

natural-sort: function/with [
    "Naturally sort a block of strings"
    items [block!]
][
    sort/compare items :comparator
][
    replacement: charset keys-of char-map: #[
        #"Ĳ" "IJ"  #"ĳ" "ij"
        #"Œ" "OE"  #"œ" "oe"
        #"Æ" "AE"  #"æ" "ae"
        #"ﬁ" "fi"  #"ﬂ" "fl"
        #"À" #"a"  #"Á" #"a"  #"Â" #"a"  #"Ã" #"a"  #"Ä" #"a"  #"Å" #"a"
        #"à" #"a"  #"á" #"a"  #"â" #"a"  #"ã" #"a"  #"ä" #"a"  #"å" #"a"
        #"È" #"e"  #"É" #"e"  #"Ê" #"e"  #"Ë" #"e"
        #"è" #"e"  #"é" #"e"  #"ê" #"e"  #"ë" #"e"
        #"Ì" #"i"  #"Í" #"i"  #"Î" #"i"  #"Ï" #"i"
        #"ì" #"i"  #"í" #"i"  #"î" #"i"  #"ï" #"i"
        #"Ò" #"o"  #"Ó" #"o"  #"Ô" #"o"  #"Õ" #"o"  #"Ö" #"o"  #"Ø" #"o"
        #"ò" #"o"  #"ó" #"o"  #"ô" #"o"  #"õ" #"o"  #"ö" #"o"  #"ø" #"o"
        #"Ù" #"u"  #"Ú" #"u"  #"Û" #"u"  #"Ü" #"u"
        #"ù" #"u"  #"ú" #"u"  #"û" #"u"  #"ü" #"u"
        #"Ý" #"y"  #"ý" #"y"  #"Ÿ" #"y"  #"ÿ" #"y"
        #"Ñ" #"n"  #"ñ" #"n"
        #"Ç" #"c"  #"ç" #"c"
        #"Ð" #"d"  #"ð" #"d"
        #"Þ" "th" #"þ" "th"
        #"ß" "ss" #"ſ" #"s" #"ʒ" #"s"
    ]
    space: charset [" ^-^/^M" #"^A" - #"^K"]
    normal: complement union space replacement
    digits: charset [#"0" - #"9"]
    not-digits: complement digits

    sort-key: func [
        "Generate natural sort key for string"
        string [string!]
        /local out s e
    ][
        out: clear ""
        parse string [
            ;; Trim leading whitespace
            any space
            ;; If the first word is in common-leaders ("a", "an", "the"), drop it
            opt [["an" | "a" | "the"] space]
            collect into out any [
                  keep some normal
                ;; Collapse all internal whitespace runs to a single space
                | some space keep (#" ")
                ;; For each character, apply de-accent/de-ligature/replacement via char-map
                | some [
                    set c: replacement keep (char-map/:c)
                ]
            ]
        ]
        ;; Split the result into alternating string/integer segments
        parse trim/tail out [collect any [
            s: some digits e: keep (to integer! copy/part s e)
            | end
            | keep some not-digits
        ]]
    ]

    comparator: func [a b] [
        (sort-key a) < (sort-key b)
    ]
]


test-data: [
    "# Ignoring leading spaces"
    ["ignore leading spaces: 2-2"
     " ignore leading spaces: 2-1"
     "  ignore leading spaces: 2+0"
     "   ignore leading spaces: 2+1"]

    "# Ignoring multiple adjacent spaces (m.a.s)"
    ["ignore m.a.s spaces: 2-2"
     "ignore m.a.s  spaces: 2-1"
     "ignore m.a.s   spaces: 2+0"
     "ignore m.a.s    spaces: 2+1"]

    "# Equivalent whitespace characters"
    ["Equiv. spaces: 3-3"
     "Equiv.^Mspaces: 3-2"
     "Equiv.^Aspaces: 3-1"
     "Equiv.^Kspaces: 3+0"
     "Equiv.^/spaces: 3+1"
     "Equiv.^-spaces: 3+2"]

    "# Case Indepenent sort"
    ["cASE INDEPENENT: 3-2" "caSE INDEPENENT: 3-1" "casE INDEPENENT: 3+0" "case INDEPENENT: 3+1"]

    "# Numeric fields as numerics"
    ["foo100bar99baz0.txt" "foo100bar10baz0.txt" "foo1000bar99baz10.txt" "foo1000bar99baz9.txt"]

    "# Title sorts"
    ["The Wind in the Willows" "The 40th step more" "The 39 steps" "Wanda"]

    "# Equivalent accented characters (and case)"
    ["Equiv. ý accents: 2-2" "Equiv. Ý accents: 2-1" "Equiv. y accents: 2+0" "Equiv. Y accents: 2+1"]

    "# Character replacements"
    ["Start with an ʒ: 2-2" "Start with an ſ: 2-1" "Start with an ß: 2+0" "Start with an s: 2+1"]
]

foreach [title data] test-data [
    print as-yellow title
    prin "Text strings: "
    probe new-line/all data on
    prin "Naturally sorted: " probe natural-sort copy data
    print ""
]
