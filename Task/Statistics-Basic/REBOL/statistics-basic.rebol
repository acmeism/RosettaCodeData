Rebol [
    title: "Rosetta code: Statistics/Basic"
    file:  %Statistics-Basic.r3
    url:   https://rosettacode.org/wiki/Statistics/Basic
]

generate-uniformly: function [
    "Generate a vector of uniformly distributed random decimal values."
    samples [integer!] "Number of values to generate"
    min     [decimal!] "Lower bound (inclusive)"
    max     [decimal!] "Upper bound (exclusive)"
][
    values: make vector! [f64! :samples]
    repeat i samples [ values/:i: min + random (max - min) ]
    values
]

print-histogram: function [
    "Print a histogram of values in a vector, assuming range [0.0, 1.0)."
    values [vector!] "Input data vector"
][
    width: 50.0 low: 0.0 high: 1.0 delta: 0.1
    nbins: to integer! ((high - low) / delta)           ;; number of bins
    bins:  make vector! [i32! :nbins]                   ;; per-bin counts

    ;; Assign each value to a bin
    repeat i values/length [
        j: 1 + round/floor ((values/:i - low) / delta)
        if all [(j >= 1) (j <= nbins)] [
            bins/:j: bins/:j + 1
        ]
    ]

    maxi: bins/maximum                                  ;; largest bin count (for scaling)

    print ""
    print ["Values:" values/length]
    print ["Mean  :" values/mean]
    print ["StdDev:" values/sample-deviation]
    print-hline/width 75

    repeat j nbins [
        bin-low:  j - 1 * delta + low
        bin-high: j     * delta + low
        s: ajoin [pad j -2 " [" bin-low " " bin-high "] "]
        append/dup s #"▉" width * bins/:j / maxi       ;; bar scaled to max count
        append s ajoin [SP round/to (bins/:j * 100 / values/length) 0.01 "%"]
        print s
    ]

    print-hline/width 75
]

random/seed now/time/precise

foreach size [100 1000 10000 10000 1000000] [
    print-histogram generate-uniformly size 0.0 1.0
]

