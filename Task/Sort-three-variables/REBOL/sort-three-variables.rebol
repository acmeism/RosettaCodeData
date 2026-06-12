Rebol [
    title: "Rosetta code: Sort three variables"
    file:  %Sort_three_variables.r3
    url:   https://rosettacode.org/wiki/Sort_three_variables
]

foreach [x y z] [
    "lions, tigers, and" "bears, oh my!" {(from the "Wizard of OZ")}
    77444  -12  0
    3.1416  3.1415926  3.141592654
    #"z"  #"0"  #"A"
    216.239.36.21  172.67.134.114  127.0.0.1
    john@doe.org  max@min.com  cool@bi.net
    potato  carrot  cabbage
][
    set [x y z] sort reduce [x y z]
    printf ["x: " 28 "y: " 20 "z: "][mold x mold y mold z]
]
