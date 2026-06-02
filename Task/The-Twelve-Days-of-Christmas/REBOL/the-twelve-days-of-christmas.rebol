Rebol [
    title: "Rosetta code: The Twelve Days of Christmas"
    file:  %The_Twelve_Days_of_Christmas.r3
    url:   https://rosettacode.org/wiki/The_Twelve_Days_of_Christmas
]

gifts: [
    "A partridge in a pear tree."  "Two turtle doves, and"
    "Three french hens,"           "Four calling birds,"
    "Five golden rings,"           "Six geese a-laying,"
    "Seven swans a-swimming,"      "Eight maids a-milking,"
    "Nine ladies dancing,"         "Ten lords a-leaping,"
    "Eleven pipers piping,"        "Twelve drummers drumming,"
]
days: [
    first second third fourth fifth sixth
    seventh eighth ninth tenth eleventh twelfth
]

for day 1 12 1 [
    print ["^/On the" as-green days/:day "day of Christmas"]
    print "My true love gave to me:^/"
    for gift day 1 -1 [ print [tab gifts/:gift] ]
]
