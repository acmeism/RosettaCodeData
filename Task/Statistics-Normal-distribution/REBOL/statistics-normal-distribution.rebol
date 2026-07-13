Rebol [
    title: "Rosetta code: Statistics/Normal_distribution"
    file:  %Statistics-Normal_distribution.r3
    url:   https://rosettacode.org/wiki/Statistics/Normal_distribution
    author: @ldci
    needs: 3.19.0
]

random/seed 1
randMax: 2147483647  ;; max integer value
nMax: 500000         ;; number of random values, can be modified

;; Normal random numbers generator using Marsaglia algorithm.
;; Generates 2 independent series of random values in the range [-1.0, 1.0].
generate: function [
    n [integer!]  ;; number of pairs to generate
][
    m: n * 2
    values: make vector! [f64! :m]  ;; vector to hold generated values
    for i 1 m 2 [
        rsq: 0.0
        ;; Repeat while radius squared is outside the unit circle or zero
        while [any [(rsq >= 1.0) (rsq == 0.0)]] [
            x: (2.0 * random randMax) / randMax - 1.0
            y: (2.0 * random randMax) / randMax - 1.0
            rsq: (x * x) + (y * y)
        ]
        f: sqrt ((-2.0 * log-e rsq) / rsq)
        values/(i): x * f
        values/(i + 1): y * f
    ]
    values
]

print-histogram: function [
    "Print a histogram of values in a vector, assuming range [-3.0, 3.0)."
    values [vector!] "Input data vector"
][
    width: 50.0           ;; width of histogram bars
    low:  -3.0            ;; lower bound of histogram
    high:  3.0            ;; upper bound of histogram
    delta: 0.1            ;; bin width
    n: values/length      ;; length of data
    nbins: to integer! ((high - low) / delta)  ;; number of bins
    bins: make vector! [i32! :nbins]  ;; initialize bins vector
    repeat i n [
        j: 1 + round/floor ((values/:i - low) / delta)
        if all [(j >= 1) (j <= nbins)] [
            bins/:j: bins/:j + 1  ;; increment bin counter
        ]
    ]
    maxi: bins/maximum  ;; max count in any bin
    repeat j nbins [
        lbin: round/to (j - 1 * delta + low) 0.01
        hbin: round/to (j     * delta + low) 0.01
        s: ajoin ["[" pad lbin -5 SP pad hbin -5 "] "]  ;; bin label string
        append/dup s #"▉" width * bins/:j / maxi       ;; bar scaled to max count
        append s ajoin [" " round/to (bins/:j * 100 / n) 0.01 "%"]  ;; append percentage
        print s
    ]
]

;;********************** Main ***********************

print "Be patient! Generating Data and Gaussian Histogram..."
print-hline

time: dt [
    values: generate nMax   ;; generate nMax pairs of random values
    print-histogram values  ;; print histogram of generated values
]

print-hline
print [nMax * 2 "Values processed in:" round/to third time 0.01 "sec"]
print ["Mean: " values/mean]
print ["STD : " values/sample-deviation]
print-hline
