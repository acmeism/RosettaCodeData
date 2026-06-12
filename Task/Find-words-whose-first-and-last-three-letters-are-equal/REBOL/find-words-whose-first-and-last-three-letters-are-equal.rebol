foreach word read/lines %unixdict.txt [
    if all [
        5 < length? word
        tmp: skip tail word -3
        parse word [tmp to end]
    ][  print word ]
]
