;; Download the dictionary if not exists
unless exists? %unixdict.txt [
    write %unixdict.txt
    read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
;; Find all words containing "the" substring longer than 11 chars
foreach word read/lines %unixdict.txt [
    if all [
        11 < length? word
        find word "the"
    ][ print word ]
]
