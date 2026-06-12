Rebol [
    title: "Rosetta code: ABC words"
    file:  %ABC_words.r3
    url:   https://rosettacode.org/wiki/ABC_words
]
;; Load or fetch the dictionary
unless exists? %unixdict.txt [
    write %unixdict.txt
    read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
abc-word?: function[word][
    all [
        a: index? find word #"a"
        b: index? find word #"b"
        a < b
        c: index? find word #"c"
        b < c
    ]
]
result: copy []
foreach word read/lines %unixdict.txt [
    if abc-word? word [ append result word ]
]

print ["Found" as-yellow length? result "ABC words:"]
foreach word result [print word]
