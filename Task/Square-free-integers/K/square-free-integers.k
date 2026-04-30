Trillion: */12#10
Limit: Trillion + 145
p: `pri 1+_%Limit

sqf: {
    a: 1+_%x
    &/ ~0= ({x*x}' (1+p'a)#p) !' x}

pm: { /print matrix
    fw: -(3 + _(|/`ln x) % `ln 10)
    `0: (,/fw$$)'(0N;y) # x}

`0: "The square free numbers up to 145:"
pm[1+&sqf'1_!146; 15]

`0: ""
`0: "The square free numbers from 1e12 - 1e12+145"
pm[Trillion + &sqf'Trillion + !146; 5]

`0: ""
`0: "Counts of square free numbers <= 100, 1000, ... 1e6"
`0: $1_+\#'.=(#$)' 1+&sqf'1_!1000001
