Rebol [
    title: "Rosetta code: Fractran"
    file:  %Fractran.r3
    url:   https://rosettacode.org/wiki/Fractran
]

fractran: function/with [
    input [string! file! url!]
    start [integer!]
    terms [integer!]
][
    unless string? input [ input: read/string input ]
    ;; --- parse fractions into [numerator denominator] pairs ---
    fractions: parse input [collect [fraction some [separator fraction]]]
    ;; --- interpreter loop ---
    out: append copy [] n: start
    while [terms > length? out] [
        forall fractions [
            frac: fractions/1
            if zero? mod n frac/y [         ;; fraction applies: n is divisible
                n: n / frac/y * frac/x      ;; advance: multiply n by fraction
                append out to integer! n    ;; keep the result
                fractions: head fractions   ;; restart from first fraction
                break
            ]
            if tail? fractions [return out] ;; no fraction applied: halt
        ]
    ]
    out
][
    digit:     charset "0123456789"
    fraction:  [copy p [some digit] #"/" copy q [some digit] keep (as-pair to integer! p to integer! q)]
    separator: [some #" "]
]

print "First 100 terms of the sequence:"
out: fractran "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1" 2 100
forall out [
    prin pad out/1 9
    if zero? mod index? out 10 [print ""]
]
