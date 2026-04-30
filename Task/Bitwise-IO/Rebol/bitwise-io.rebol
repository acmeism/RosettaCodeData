Rebol [
    title: "Rosetta code: Bitwise IO"
    file:  %Bitwise_IO.r3
    url:   https://rosettacode.org/wiki/Bitwise_IO
    note:  "Based on Vasyl Zubko's Red language implementation!"
]

compress-7bit: function [
    "Pack 8-bit bytes into 7-bit chunks (lossless for 7-bit ASCII)"
    str [string! binary!]
][
    buf:  clear ""                       ;; string buffer for 7-bit bitstream
    bits: enbase/flat str 2              ;; convert input to a flat binary string "0101..."
    while [not tail? bits][              ;; take 7 bits out of every 8
        append buf copy/part next bits 7 ;; append bits 2..8 (skip the first bit of each byte)
        bits: skip bits 8                ;; move to next 8-bit group
    ]
    ;; Pad to multiple of 8 bits so it can be debased to bytes
    unless zero? (pad-bits: (length? buf) // 8) [
        append/dup buf #"0" 8 - pad-bits
    ]
    debase buf 2                        ;; turn the 7-bit stream (padded) back into binary bytes
]

decompress-7bit: function [
    "Unpack 7-bit chunks back to 8-bit by re-inserting the leading zero bit per group of 7"
    bin [binary!]
][
    bits: enbase/flat bin 2             ;; bitstring of the compressed bytes
    filled: 0                           ;; counter within a 7-bit group
    buf: clear #{}                      ;; output binary buffer
    acc: clear ""                       ;; accumulator for 7 bits

    foreach bit bits [
        append acc bit                  ;; collect one bit
        filled: filled + 1
        if filled = 7 [
            ;; Prepend a '0' to restore 8th bit, debase to a byte, append to output
            append buf debase join #"0" acc 2
            clear acc
            filled: 0
        ]
    ]
    ;; If padding produced a final 0 byte, drop it
    if 0 == last buf [take/last buf]
    to string! buf                      ;; return original as string
]

;- DEMO:
in-string: "Rebol is not dead!"
compressed: compress-7bit in-string    ;; compress to 7-bit packed binary
expanded:   decompress-7bit compressed ;; decompress back to original

print [
    "^/in-string :"  in-string
    "^/in-binary :"  to binary! in-string
    "^/compressed:"  compressed
    "^/expanded  :"  expanded
]
