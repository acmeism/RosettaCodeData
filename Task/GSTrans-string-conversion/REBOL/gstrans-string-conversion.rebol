Rebol [
    title: "Rosetta code: GSTrans string conversion"
    file: %GSTrans_string_conversion.r3
    url: https://rosettacode.org/wiki/GSTrans_string_conversion
    needs: 3.0.0
]
register-codec [
    name:  'GSTrans
    type:  'text
    encode: function [data [binary! any-string!]][
        o: copy ""
        foreach c to binary! data [
            if c > 127 [append o "|!" c: c - 128]
            case [
                c < 32    [append append o #"|" #"@" + c]
                c = #"^"" [append o {|"}]
                c = #"|"  [append o "||"]
                c = #"<"  [append o "|<"]
                c < 127   [append o to char! c]
                c = 127   [append o "|?"]
            ]
        ]
        o
    ]
    decode: function [data [binary! any-string!]][
        c: none
        o: copy #{}
        parse data [some [
            #"|" [
                #"!" [
                    #"|" [
                        set c [#"^"" | #"|" | #"<"] (append o 128 + c)
                        | #"?" (append o 255)
                        | set c skip (append o 64  + uppercase c)
                    ]
                    | set c skip (append o 128 + c)
                ]
                | #"?" (append o 127)
                | set c [#"|" | #"^""] (append o c)
                | set c skip (append o (uppercase c) - #"@")
            ]
            | copy c to [#"|" | end] (append o c)
            | skip
        ]]
        try [o: to string! o]
        o
    ]
]

assert ["|M|J|@|E|!t|M|!|?" = codecs/gstrans/encode #{0D 0A 00 05 F4 0D FF}]
assert [#{0D 0A 00 05 F4 0D FF} = codecs/gstrans/decode "|m|j|@|e|!t|m|!|?"]

foreach str [
    "ALERT|G"
    "wert↑"
    "@♂aN°$ª7Î"
    "ÙC▼æÔt6¤☻Ì"
    {"@)Ð♠qhýÌÿ}
    "+☻#o9$u♠©A"
    "♣àlæi6Ú.é"
    "ÏÔ♀È♥@ë"
    "Rç÷%◄MZûhZ"
    "ç>¾AôVâ♫↓P"

][
    print ["Source: " mold str]
    print ["Encoded:" mold enc: encode 'GSTrans str]
    print ["Decoded:" mold dec: decode 'GSTrans enc]
    if not equal? str dec [print as-red "FAILED!"]
    print "---"
]
