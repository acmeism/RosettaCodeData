Rebol [
    title: "Rosetta code: Integer overflow"
    file:  %Integer_overflow.r3
    url:   https://rosettacode.org/wiki/Integer_overflow
]

foreach expr [
    ;; For 32-bit signed integers:
    [negate (-2147483647 - 1)                  ]
    [2000000000 + 2000000000                   ]
    [-2147483647 - 2147483647                  ]
    [46341 * 46341                             ]
    [(-2147483647 - 1) / -1                    ]
    ;; For 64-bit signed integers:
    [negate (-9223372036854775807 - 1)         ]
    [5000000000000000000 + 5000000000000000000 ]
    [-9223372036854775807 - 9223372036854775807]
    [3037000500 * 3037000500                   ]
    [(-9223372036854775807 - 1) / -1           ]
    ;; For 32-bit unsigned integers:
    [-4294967295                               ]
    [3000000000 + 3000000000                   ]
    [2147483647 - 4294967295                   ]
    [65537 * 65537                             ]
    ;; For 64-bit unsigned integers:
    [transcode "-18446744073709551615"         ]
    [transcode " 10000000000000000000"         ]
    [transcode " 18446744073709551615"         ]
    [4294967296 * 4294967296                   ]
][
    prin [pad mold/only expr 44 ";== "]
    print either error? res: try expr [as-red reform [res/type res/id]][res]
]
