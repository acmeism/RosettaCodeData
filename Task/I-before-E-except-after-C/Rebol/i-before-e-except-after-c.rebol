Rebol [
    title: "Rosetta code: I before E except after C"
    file:  %I_before_E_except_after_C.r3
    url:   https://rosettacode.org/wiki/I_before_E_except_after_C
    note:  "Based on Red language solution"
    needs: 3.15.0 ;; or something like that
]

testlist: function [wordlist /wfreq] [
    ;; Initialize counters for each pattern
    cie: cei: ie: ei: 0

    ;; Select iteration mode: if /wfreq, expect [word freq] pairs; else assume word-only
    words: either wfreq [[word freq]][freq: 1 [word]]

    ;; Loop through each word or [word freq] pair in the list
    foreach :words wordlist [
        ;; Use PARSE to search for each pattern within the word string
        parse word [ some [
            "cie" (cie: cie + freq) |   ;; Count "cie" and increment by frequency
            "cei" (cei: cei + freq) |   ;; Count "cei" and increment by frequency
            "ie"  ( ie:  ie + freq) |   ;; Count standalone "ie" not preceded by c
            "ei"  ( ei:  ei + freq) |   ;; Count standalone "ei" not preceded by c
            skip
        ]]
    ]
    ;; Print results, comparing "i before e except after c" rule against pattern frequencies
    print rejoin [
        "i is before e " ie " times, and also " cie " times following c.^/"
        "i is after e " ei " times, and also " cei " times following c.^/"
        "Hence ^"i before e^" is " either a: 2 * ei < ie [""] ["not "] "plausible,^/"
        "while ^"except after c^" is " either b: 2 * cie < cei [""] ["not "] "plausible.^/"
        "Overall the rule is " either a and b [""] ["not "] "plausible."
    ]
]

print "Results for unixdict.txt:"
testlist read/lines %unixdict.txt

print "^/Results for British National Corpus:"
bnc: next read/lines %1_2_all_freq.txt
spaces: charset "^- "
bnclist: collect [
    foreach w bnc [
        if 3 = length? seq: split trim w spaces [
            keep seq/1 keep to-integer seq/3
        ]
    ]
]
testlist/wfreq bnclist
