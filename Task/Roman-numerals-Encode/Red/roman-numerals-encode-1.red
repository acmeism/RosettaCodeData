table: [1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL 10 X 5 V 4 IV 1 I]

to-Roman: function [n [integer!] return: [string!]][
    out: copy ""
    foreach [a r] table [while [n >= a][append out r n: n - a]]
    out
]

foreach number [40 33 1888 2016][print [number ":" to-Roman number]]
