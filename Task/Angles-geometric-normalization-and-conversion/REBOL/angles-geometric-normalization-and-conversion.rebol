Rebol [
    title: "Rosetta code: Angles (geometric), normalization and conversion"
    file:  %"Angles_(geometric),_normalization_and_conversion.r3"
    url:   https://rosettacode.org/wiki/Angles_%28geometric%29%2C_normalization_and_conversion
]

convert-angle: function/with [
    "Convert a numeric angle value from one unit to another."
    value [number!]   "The angle value to convert"
    src   [any-word!] "Source unit: 'degrees, 'gradians, 'mils, or 'radians"
    tgt   [any-word!] "Target unit: 'degrees, 'gradians, 'mils, or 'radians"
][
    (remainder (value * turns/:src) 1) / turns/:tgt
][
    turns: compose [
        degrees:  (1 / 360)
        gradians: (1 / 400)
        mils:     (1 / 6400)
        radians:  (0.5 / pi)
    ]
]

tests: reduce [-2 -1 0 1 2 (2 * pi) 16 57.2957795 359 399 6399 1000000]
units: [degrees gradians mils radians]

print "    angle unit          degrees   gradians       mils    radians"
foreach value tests [
    foreach unit units [
        prin format [-9 SP 10][value unit]
        foreach tgt units [
            prin format ["  " -9] convert-angle value unit tgt
        ]
        print ""
    ]
    print ""
]
