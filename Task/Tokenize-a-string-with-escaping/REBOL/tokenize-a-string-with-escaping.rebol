Rebol [
    title: "Rosetta code: Tokenize a string with escaping"
    file:  %Tokenize_a_string_with_escaping.r3
    url:   https://rosettacode.org/wiki/Tokenize_a_string_with_escaping
]

split-escaped: function[
    string  [string!]  "input string to split"
    separator [char!]  "delimiter character"
    escape    [char!]  "escape character (protects next char)"
][
    chars: complement charset join separator escape
    ;; chars = all characters except separator and escape

    out: copy []                    ;; result block

    parse string [
        any [
            (token: copy "")        ;; start a new token
            collect into token any [
                  keep some chars   ;; collect normal characters
                | escape keep skip  ;; escaped char: skip escape, keep next char
            ]
            (append out token)      ;; store token in result
            opt separator           ;; optionally consume separator
        ]
    ]

    out  ;; return collected tokens
]

probe split-escaped "one\|uno||three\\\\|four\\\|\cuatro|" #"|" #"\"
