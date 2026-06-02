Rebol [
    title: "Rosetta code: Sparkline in unicode"
    file:  %Sparkline_in_unicode.r3
    url:   https://rosettacode.org/wiki/Sparkline_in_unicode
]

print-spark-line: function/with [
    "Print a sparkline bar chart for a sequence of numbers"
    numbers [string! block! vector!]
][
    if string? numbers [numbers: transcode numbers]        ;; parse string to block
    if block?  numbers [numbers: make vector! numbers]     ;; normalize to vector
    set [mn: mx: extent:] query numbers [:min :max :range] ;; extract stats in one call
    line: clear ""
    foreach n numbers [
        i: 1 + to integer! barcount * (n - mn) / extent    ;; map value to bar index
        append line bar/(min i barcount)                   ;; clamp and append bar char
    ]
    printf ["min: " 0.1 " max: " 0.1 " range: " 0.1] [mn mx extent]
    print line
    print ""
][
    bar: "▁▂▃▄▅▆▇█"
    barcount: length? bar
]

print-spark-line #(i8![1 2 3 4 5 6 7 8 7 6 5 4 3 2 1])
print-spark-line [1.5 0.5 3.5 2.5 5.5 4.5 7.5 6.5]
print-spark-line "3 2 1 0 -1 -2 -3 -4 -3 -2 -1 0 1 2 3"
