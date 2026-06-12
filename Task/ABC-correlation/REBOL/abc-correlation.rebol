Rebol [
    title: "Rosetta code: ABC correlation"
    file:  %ABC_correlation.r3
    url:   https://rosettacode.org/wiki/ABC_correlation
]
;; Load or fetch the dictionary
unless exists? %unixdict.txt [
    write %unixdict.txt
    read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
abc-word?: function[
    {Return true if word contain equal numbers of "a", "b" and "c" characters}
    word
][
    a: b: c: 0
    parse word [
        some [
            #"a" (++ a) | #"b" (++ b) | #"c" (++ c) | skip
        ]
    ]
    all [a > 0 a == b a == c]
]
result: copy []
foreach word read/lines %unixdict.txt [
    if abc-word? word [ append result word ]
]

print ["Found" as-yellow length? result "ABC words:"]
foreach word copy/part result 10 [print word]
