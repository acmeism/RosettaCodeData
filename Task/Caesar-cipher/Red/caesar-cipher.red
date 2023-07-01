Red ["Ceasar Cipher"]

rot: func [
    char [char!]
    key  [number!]
    ofs  [char!]
][
    to-char key + char - ofs // 26 + ofs
]

caesar: function [
    src [string!]
    key [integer!]
][
    lower: charset [#"a" - #"z"]
    upper: charset [#"A" - #"Z"]
    parse src [
        any [
            change s: [lower (o: #"a") | upper (o: #"A")] (rot s/1 key o)
          | skip
        ]
    ]
    src
]

encrypt: :caesar
decrypt: func spec-of :caesar [caesar src negate key]
