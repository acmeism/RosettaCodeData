Rebol [
    title: "Rosetta code: Huffman coding"
    file:  %Huffman_coding.r3
    url:   https://rosettacode.org/wiki/Huffman_coding
    note:  "Based on Red language solution"
    needs: 3.15.0 ;; or something like that
]

register-codec [
    name: 'huffman                         ;; Codec identifier name
    type: 'compression                     ;; Type: compression algorithm
    title: "Huffman encoding example"      ;; User-facing title

    decode: function [
        "Huffman decoding"
        data [any-string!]
    ][
        output: copy ""                    ;; Initialize the output string
        while [ not empty? data ][         ;; Loop through encoded data until empty
            foreach [k v] knots [          ;; For each character-knot mapping
                if t: find/match/tail data v/code [   ;; Check if the encoded string starts with the knot's code
                    append output k        ;; If so, append the corresponding character to output
                    data: t                ;; Consume matched part from data
                ]
            ]
        ]
        output                             ;; Return the decoded string
    ]

    encode: func [
        "Huffman encoding"
        data [any-string! binary!]
        /local k nknot output
    ][
        output: copy ""                    ;; Initialize output string
        foreach chr data [                 ;; For each character in input
            either k: select/case knots chr [ ;; If knot already exists for the character
                k/count: k/count + 1       ;; Increment frequency count
            ][
                ;; Otherwise, create new knot object and add to map
                nknot: make knot [code: chr]
                put/case knots chr nknot
            ]
        ]
        table: values-of knots             ;; Extract all knots
        while [1 < length? table][         ;; Build Huffman tree until only root remains
            sort/compare table :compare-knots ;; Sort knots by ascending frequency
            merge-2knots table             ;; Merge two lowest-count knots into new parent knot
        ]
        set-code table/1 copy ""           ;; Recursively assign binary codes by tree depth
        foreach chr msg [                  ;; Encode the original message
            k: select/case knots chr
            append output k/code           ;; Append binary code for each character
        ]
        output                             ;; Return Huffman encoded string
    ]

    knot: make object! [
        left: right: none                  ;; References to left and right children in the binary tree
        code: none                         ;; Stores char (debug) and binary code for encoding
        count: depth: 1                    ;; Frequency count and branch/tree depth
    ]

    knots: make map! []                    ;; Map to store character -> knot objects
    table: none                            ;; Used for sorting the tree

    compare-knots: function [a b] [
        any [
            a/count < b/count
            all [
                a/count = b/count
                a/depth > b/depth
            ]
        ]
    ]

    set-code: func  [
        "Recursive function to generate binary code sequence"
        wknot
        wcode [string!]
    ][
        either wknot/left [
            set-code wknot/left  join wcode "1"     ;; Assign '1' when going left
            set-code wknot/right join wcode "0"     ;; Assign '0' when going right
        ][  wknot/code:  wcode ]                    ;; Assign accumulated code when leaf is reached
    ]

    merge-2knots: func [
        "Merge 2 knots into 1 new"
        t [block!]
    ][
        nknot: make knot [
            count: t/1/count + t/2/count            ;; Sum frequencies for merged knot
            right: t/1
            left:  t/2
            depth: t/1/depth + 1                    ;; Increase depth
        ]
        remove/part t 2                             ;; Remove first two knots from table
        insert t nknot                              ;; Insert new knot at head of table
    ]
]

;; message to encode:
message: "this is an example for huffman encoding" ;; Input text for encoding
? message                                          ;; Print message
encoded: encode 'huffman message                   ;; Huffman encode the message
? encoded                                          ;; Print encoded result
decoded: decode 'huffman encoded                   ;; Decode Huffman encoding back to string
? decoded                                          ;; Print decoded result
print "Used codes:"
foreach [k v] codecs/huffman/knots [print [mold k mold v/code]]
