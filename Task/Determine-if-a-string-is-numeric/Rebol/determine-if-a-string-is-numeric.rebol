Rebol [
	Title: "Is Numeric?"
	URL: http://rosettacode.org/wiki/IsNumeric
]
; Built-in.
numeric?: func [x][decimal? try [to decimal! x]]

; Parse dialect for numbers.
pnumeric?: function/with [x][
    parse x number
][
    sign:   [0 1 [#"-" | #"+"]]
    digit:  charset "0123456789"
    int:    [some digit]
    float:  [int "." int]
    number: [
        sign float ["e" | "E"] sign int |
        sign int ["e" | "E"] sign int |
        sign float |
        sign int
    ]
]

; Test cases.
valid: [
    "10" "-99" "10.43" "-12.04" "1e99" "1.0e10" "-10e3" "-9.12e7" "2e-4" "-3.4E-5"
]
invalid: [
    "3phase" "Garkenhammer" "e" "n3v3r" "phase3"
]

print "^/Valid cases:"
foreach x valid   [print [mold x  numeric? x  pnumeric? x]]
print "^/Invalid cases:"
foreach x invalid [print [mold x  numeric? x  pnumeric? x]]
