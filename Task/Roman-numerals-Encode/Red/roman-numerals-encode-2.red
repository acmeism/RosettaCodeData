Red []

table: [1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL 10 X 9 IX 5 V 4 IV 1 I]

to-Roman: func [n [integer!] return: [string!]][
    case [
        tail? table [table: head table copy ""]
        table/1 > n [table: skip table 2 to-Roman n]
        'else       [append copy form table/2 to-Roman n - table/1]
    ]
]

foreach number [40 33 1888 2016][print [number ":" to-Roman number]]
