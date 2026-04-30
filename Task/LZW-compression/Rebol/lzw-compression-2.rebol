Rebol [
    title: "Rosetta code: LZW compression"
    file:  %LZW_compression.r3
    url:   https://rosettacode.org/wiki/LZW_compression
]
lzw-compress: function [str [string! binary!]] [
    ;; Initialize dictionary with all single-byte entries (0-255)
    ;; Keys are binary! series (e.g. #{00}, #{01}, ..., #{FF})
    ;; Values are their corresponding integer codes
    ;; Using binary! keys avoids string encoding issues with non-ASCII bytes
    dict: copy #[]
    for i 0 255 1 [ dict/(join #{} i): i ]
    ;; w is the current match buffer as a binary! series
    ;; clear #{} gives us a reusable empty binary! to build patterns into
    w: clear #{}
    result: copy []
    foreach c to binary! str [
        ;; Extend current pattern by appending the new byte c
        ;; join creates a new binary! series each time (w is not mutated here)
        wc: join w c
        either dict/:wc [
            ;; Extended pattern wc exists in dictionary — keep growing the match
            ;; w now points to the new longer series wc
            w: wc
        ][
            ;; Extended pattern wc is new — emit code for longest known match w
            append result dict/:w
            ;; Register the new pattern wc in the dictionary with the next code
            dict/:wc: length? dict
            ;; Reuse w's storage by clearing it and appending just the current byte
            ;; This avoids allocating a new binary! series for the reset
            append clear w c
        ]
    ]
    ;; Flush the last buffered pattern if anything remains in w
    if (length? w) > 0 [ append result select dict w ]
    result
]
lzw-decompress: function [codes [block!]] [
    ;; Initialize the reverse dictionary (code -> binary) for ASCII 0-255
    ;; This is the inverse of the compress dictionary
    dict: copy []
    for i 0 255 1 [append dict join #{} i]

    ;; Read the first code and convert it to a binary to start the output
    w: join #{} codes/1
    result: copy w
    foreach code next codes [
        unless entry: pickz dict code [
            ;; Code not yet in dict (pattern references itself)
            ;; This happens when the encoder emits a code it just added
            assert [code = length? dict]
            ;; The new entry is the previous pattern + its own first byte
            entry: join w w/1
        ]
        ;; Emit the decoded entry to output
        append result entry
        ;; Add new dictionary entry: previous pattern + first byte of current entry
        append dict join w entry/1
        ;; Current entry becomes the new previous pattern
        w: entry
    ]
    to string! result
]

foreach text [
    "TOBEORNOTTOBEORTOBEORNOT"
    "štěstí v neštěstí"
][
    print ["Original:    " text]
    print ["Compresed:   " blk: lzw-compress text]
    print ["Decompressed:" lzw-decompress blk]
    prin LF
]
