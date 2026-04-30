Rebol [
    title: "Rosetta code: Bifid cipher"
    file:  %Bifid_cipher.r3
    url:   https://rosettacode.org/wiki/Bifid_cipher
]

make-square: function [
    {Build a Polybius square from an alphabet string.
    Returns a block of rows, each row a block of single-character strings.
    The square is sized ceil(sqrt(len)) x ceil(sqrt(len)), with none padding
    if the alphabet does not fill the last row exactly.}
    alphabet [string!]
][
    size: to-integer round/ceiling square-root length? alphabet
    rows: copy []
    row:  copy []
    i:    0
    foreach ch alphabet [
        append row ch
        ++ i
        if i = size [
            append/only rows row
            row: copy []
            i:  0
        ]
    ]
    unless empty? row [                        ;; pad final row with none
        append/dup row none (size - length? row)
        append/only rows row
    ]
    new-line/all rows true
]

square-map: function [
    {Return a map of character -> [row col] (1-based) for the given square.}
    square [block!]
][
    m: make map! 64
    r: 1
    foreach row square [
        c: 1
        foreach ch row [
            if ch [ m/:ch: reduce [r c] ]      ; skip none padding
            ++ c
        ]
        ++ r
    ]
    m
]

encrypt: function [
    {Encrypt plaintext using the bifid cipher with the given Polybius square.
    Collects all row coordinates then all column coordinates, pairs them up,
    and maps each pair back through the square.}
    message [string!]
    square  [block!]
][
    m:    square-map square
    rows: copy []
    cols: copy []
    foreach ch message [
        if coord: m/:ch [
            append rows coord/1
            append cols coord/2
        ]
    ]
    combined: append copy rows cols        ;; [r1 r2 .. rN c1 c2 .. cN]
    result: copy ""
    i: 1
    while [i < length? combined] [
        r: pick combined i
        c: pick combined i + 1
        append result pick (pick square r) c
        i: i + 2
    ]
    result
]

decrypt: function [
    {Decrypt ciphertext using the bifid cipher with the given Polybius square.
    Splits the coordinate stream into the first half (rows) and second half
    (cols), zips them, and maps each pair back through the square.}
    message [string!]
    square  [block!]
][
    m:      square-map square
    coords: copy []
    foreach ch message [
        if coord: m/:ch [ repend coords coord ]
    ]
    half: (length? coords) / 2             ;; split interleaved coords at midpoint
    rows:   copy/part coords half
    cols:   copy/part (skip coords half) half
    result: copy ""
    i: 1
    while [i <= half] [
        r: rows/:i
        c: cols/:i
        append result square/:r/:c
        ++ i
    ]
    result
]

normalize: func [
    {Replace J with I for a standard 25-letter Polybius square.}
    message [string!]
][
    replace/all copy message "J" "I"
]

; --- Polybius squares used in test cases ---

typical-square:  make-square "ABCDEFGHIKLMNOPQRSTUVWXYZ"  ;; 25 letters, no J
example-square:  make-square "BGWKZQPNDSIOAXEFCLUMTHYVR"
playfair-square: make-square "PLAYFIREXMBCDGHKNOQSTUVWZ"
digits-square:  make-square  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

; --- Test cases ---

test-cases: reduce [
    "ATTACKATDAWN" typical-square
    "FLEEATONCE"   example-square
    "FLEEATONCE"   typical-square
    normalize "The invasion will start on the first of January" playfair-square
              "The invasion will start on the first of January"   digits-square
]

foreach [msg square] test-cases [
    probe square
    enc:  encrypt msg square
    dec:  decrypt enc square
    print ["Message  :" msg]
    print ["Encrypted:" enc]
    print ["Decrypted:" dec]
    print ""
]
