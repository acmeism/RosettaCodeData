Rebol [
    title: "Rosetta code: Caesar cipher"
    file:  %Caesar_cipher.r3
    url:    https://rosettacode.org/wiki/Caesar_cipher
    needs:  3.0.0
    note:  {Based on Red language version}
]

caesar: function/with [
    src [string!]
    key [integer!]
][
    parse/case src [
        any [
            change s: [lower (o: #"a") | upper (o: #"A")] (rot s/1 key o)
          | skip
        ]
    ]
    src
][
    lower: charset [#"a" - #"z"]
    upper: charset [#"A" - #"Z"]
    rot: func [
        char [char!]
        key  [number!]
        ofs  [char!]
    ][
        to char! key + char - ofs // 26 + ofs
    ]
]

encrypt: :caesar
decrypt: func spec-of :caesar [caesar src negate key]

;; DEMO:
print encrypt "Ceasar Cipher" 4 ;== Giewev Gmtliv
print decrypt "Giewev Gmtliv" 4 ;== Ceasar Cipher
